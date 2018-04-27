class TextualMarking
  @@base_url = ENV['TEXTUAL_MARKING_URL']

  def initialize(module_id:, coursework_id:, lecturer_id:, student_id: nil)
    @module_id = module_id
    @coursework_id = coursework_id
    @lecturer_id = lecturer_id
    @student_id = student_id
  end

  def has_tests?
    response = RestClient.get "#{@@base_url}/has_tests", :params => query_params
    JSON.parse(response.body)['has_tests']
  end

  def submit_solution(file)
    begin
      RestClient.post "#{@@base_url}/solution", post_body(file)
      {}
    rescue RestClient::ExceptionWithResponse => e
      { 'errors' => JSON.parse(e.response.body)['errors'] }
    end
  end

  def get_marked_solution
    begin
      response = RestClient.get "#{@@base_url}/solution", :params => query_params
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
      RestClient.post "#{@@base_url}/tests", post_body(file)
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