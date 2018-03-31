class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :refresh_token, :set_auth_header

  def current_user
    @current_user ||= User.find_by(:jwt => session[:jwt])
  end

  private
    def refresh_token
      session[:jwt] = Auth.new.verify_token(session[:jwt])

      if session[:jwt].blank?
        redirect_to :login
      end
    end

    def set_auth_header
      Thread.current['active.resource.currentthread.headers'] = session[:jwt]
    end
end
