class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :refresh_token, :set_auth_header

  @auth = Auth.new

  def current_user
    @current_user ||= User.find_by(:jwt => session[:jwt])
  end

  private
    def refresh_token
      response = @auth.verify_token(session[:jwt])

      if response.code == :ok
        session[:jwt] = JSON.parse(response.body)['jwt']
      else
        # redirect
      end
    end

    def set_auth_header
      ActiveResource::Base.auth_token = session[:jwt]
    end
end
