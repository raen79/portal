class AuthController < ApplicationController
  skip_before_action :refresh_token, :set_auth_header, :only => [:login, :login_form]
  before_action :set_breadcrumbs
  before_action :redirect_to_index, :only => [:login_form]

  def login_form; end

  def login
    session[:jwt] = Auth.new.login(login_params[:email], login_params[:password])

    if session[:jwt].blank?
      render :login_form
    else
      redirect_to :index
    end
  end

  def logout
    session[:jwt] = nil
    redirect_to :login
  end

  private
    def login_params
      params.require(:user).permit(:email, :password)
    end

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def redirect_to_index
      unless session[:jwt].blank?
        redirect_to :index
      end
    end
end
