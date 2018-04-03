class Faqs

  def initialize(coursework:)
    @coursework = coursework
    @course_module = coursework.course_module
    @lecturer = coursework.lecturer
  end
  
  def find(id)
    Faq.find(id, :params => { :coursework_id => @coursework.id })
  end

  def new(params = {})
    @faq = Faq.new(params)
    @faq.coursework = @coursework
    @faq.prefix_options[:coursework_id] = @coursework.id
    @faq
  end

  def all
    begin
      Faq.all(:params => { :coursework_id => @coursework.id })
    rescue
      []
    end
  end
end