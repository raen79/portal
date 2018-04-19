class ChatbotController < ApplicationController
  before_action :set_course_module, :set_coursework, :set_breadcrumbs

  def index
    @lecturer_id = @course_module.lecturer.id
  end

  def greet
    @message = "Hello, my name is Tutor Chatbot! Do you have any questions about the \"#{@coursework.name}\" coursework?"
    render :layout => false
  end

  def new_question
    @message = params[:question]
    render :layout => false
  end

  def find_answer
    @answer = Faq.find_answer(
      :params => {
        'question' => params[:question],
        'student_id' => current_user.student_id,
        'lecturer_id' => 'C1529373',
        'module_id' => params[:course_module_id],
        'coursework_id' => params[:coursework_id]
      }
    )
    render :layout => false
  end

  private
    def set_course_module
      @course_module = CourseModule.find(params[:course_module_id])
    end

    def set_breadcrumbs
      @breadcrumbs = [
        { :name => 'Modules', :url => course_modules_path },
        { :name => @course_module.name, :url => course_module_courseworks_path(:course_module_id => @course_module.id) },
        {
          :name => "#{@coursework.name} Chatbot",
          :url => course_module_coursework_chatbot_path(:course_module_id => @course_module.id, :coursework_id => @coursework.id)
        }
      ]
    end

    def set_coursework
      @coursework = @course_module.courseworks.find(params[:coursework_id])
    end
end
