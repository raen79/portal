class Faq < ActiveResource::Base
  self.site = ENV['CHATBOT_URL']
  self.prefix = '/api/coursework/:coursework_id/'
  belongs_to :coursework

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

  def self.find_answer(params:)
    response = HTTParty.get(
      self.site.to_s + '/api/coursework/' + params['coursework_id'].to_s + '/find_answer',
      :query => params,
      :headers => {
        'Authorization' => Thread.current['active.resource.currentthread.headers'],
        'Accept' => 'application/json'
      },
    )

    JSON.parse(response.body)['answer'] if response.code == 200
  end
end
