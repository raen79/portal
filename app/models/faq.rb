class Faq < ActiveResource::Base
  self.site = ENV['CHATBOT_URL']
  self.prefix = '/api/coursework/:coursework_id/'

  attr_reader :course_module, :coursework, :lecturer

  schema do
    integer 'id'
    string 'question'
    string 'answer'
    string 'lecturer_id'
    string 'module_id'
    string 'coursework_id'
    string 'created_at'
    string 'updated_at'
  end

  def created_at
    @created_at.to_datetime unless @created_at.blank?
  end

  def updated_at
    @updated_at.to_datetime unless @updated_at.blank?
  end

  def coursework=(coursework)
    @coursework = coursework
    @coursework_id = coursework.id
    @attributes.merge!(:coursework_id => @coursework_id)

    @course_module = coursework.course_module
    @module_id = @course_module.id
    @attributes.merge!(:module_id => @module_id)
    
    @lecturer = @course_module.lecturer
    @lecturer_id = @course_module.lecturer.id
    @attributes.merge!(:lecturer_id => @lecturer_id)
  end

  class << self
    def headers
      Thread.current['active.resource.currentthread.headers']
    end

    def find_answer(params:)
      response = HTTParty.get(
        self.site.to_s + '/api/coursework/' + params['coursework_id'].to_s + '/find_answer',
        :query => params,
        :headers => {
          'Authorization' => Thread.current['active.resource.currentthread.headers']['Authorization'],
          'Accept' => 'application/json'
        }
      )

      JSON.parse(response.body)['answer'] if response.code == 200
    end
  end
end
