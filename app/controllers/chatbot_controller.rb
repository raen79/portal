class ChatbotController < ApplicationController
  def index; end

  def find_answer
    @answer = Faq.find_answer(
      :params => {
        'question' => params[:question],
        'student_id' => current_user.student_id,
        'lecturer_id' => 'C1529373',
        'module_id' => params[:module_id],
        'coursework_id' => params[:coursework_id]
      }
    )
  end
end
