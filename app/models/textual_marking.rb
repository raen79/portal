class TextualMarking
  @@base_url = ENV['TEXTUAL_MARKING_URL']

  def initialize(coursework:, student: nil)
    @module_id = coursework.course_module.id
    @coursework_id = coursework.id
    @lecturer_id = coursework.lecturer.lecturer_id
    @student_id = student.student_id unless student.blank?
  end

  def submit_solution(file)
    begin
      RestClient.post "#{@@base_url}/", post_body(file)
      {}
    rescue RestClient::ExceptionWithResponse => e
      { 'errors' => JSON.parse(e.response.body)['errors'] }
    end
  end

  def get_marked_solution
    begin
      response = RestClient.get "#{@@base_url}/get_info", :params => query_params
      parsed_response = JSON.parse(response)

      { 'score' => parsed_response['score'] }
    rescue RestClient::ExceptionWithResponse => e
      case e.response.code
      when 404
        { 
          'errors' => {
            'solution' => 'has not been submitted.'
          }
        }
      when 408
        {
          'errors' => {
            'marked solution' => 'is not yet ready.'
          }
        }
      else
        { 'errors' => JSON.parse(e.response.body)['errors'] }
      end
    end
  end

  private
    def query_params
      {
        :module_id => @module_id,
        :coursework_id => @coursework_id,
        :lecturer_id => @lecturer_id,
        :student_id => @student_id
      }        
    end

    def post_body(file)
      post_body = query_params

      post_body[:file] = file
      post_body[:multipart] = true

      post_body
    end
end