class ChatbotController < ApplicationController
  def index
    @lecturer_id = 'C1529373'
  end

  def greet
    @message = 'Hello, my name is Tutor Chatbot! Do you have any questions about the XYZ coursework?'
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
end
