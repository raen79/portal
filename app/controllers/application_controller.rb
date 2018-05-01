class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception
  before_action :refresh_token, :set_auth_header

  def current_user
    @current_user ||= User.find_by(:jwt => session[:jwt])
  end

  def restrict_to_lecturer(lecturer_id = nil)
    if lecturer_id.blank?
      redirect_to :back unless current_user.lecturer?
    else
      redirect_to :back unless current_user.lecturer_id == lecturer_id
    end
  end

  def restrict_to_students(student_id = nil)
    if student_id.blank?
      redirect_to :back unless current_user.student?
    else
      redirect_to :back unless current_user.student_id == student_id
    end
  end

  private
    def refresh_token
      jwt = request.headers['Authorization'] || session[:jwt]

      session[:jwt] = Auth.new.verify_token(jwt)

      if session[:jwt].blank?
        redirect_to :login
      end
    end

    def set_auth_header
      Thread.current['active.resource.currentthread.headers'] = {
        'Authorization' => session[:jwt]
      }
    end
end
