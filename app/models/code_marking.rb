class CodeMarking
  @@base_url = ENV['CODE_MARKING_URL']

  def initialize(coursework:, student: nil, jwt:)
    @module_id = coursework.course_module.id
    @coursework_id = coursework.id
    @lecturer_id = coursework.lecturer.lecturer_id
    @student_id = student.student_id unless student.blank?
    @jwt = "Bearer #{jwt}"
  end

  def has_tests?
    begin
      response = RestClient.get "#{@@base_url}/has_tests", { :Authorization => @jwt, :params => query_params }
      JSON.parse(response.body)['has_tests']
    rescue
      false
    end
  end

  def submit_solution(file)
    begin
      RestClient.post "#{@@base_url}/solution", post_body(file), { :Authorization => @jwt }
      {}
    rescue RestClient::ExceptionWithResponse => e
      { 'errors' => JSON.parse(e.response.body)['errors'] }
    end
  end

  def get_marked_solution
    begin
      response = RestClient.get "#{@@base_url}/solution", { :Authorization => @jwt, :params => query_params }
      parsed_response = JSON.parse(response)

      {
        'pdf_url' => parsed_response['pdf_url'],
        'txt_url' => parsed_response['txt_url']
      }
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

  def submit_tests(file)
    begin
      RestClient.post "#{@@base_url}/tests", post_body(file), { :Authorization => @jwt }
      {}
    rescue RestClient::ExceptionWithResponse => e
      { 'errors' => JSON.parse(e.response.body)['errors'] }
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