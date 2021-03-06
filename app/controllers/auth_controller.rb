class AuthController < ApplicationController
  skip_before_action :refresh_token, :set_auth_header, :only => [:login, :login_form, :register]
  before_action :set_breadcrumbs
  before_action :redirect_to_index, :only => [:login_form]

  def initialize
    super()
    
    @auth = Auth.new
    @login_errors = []
    @register_errors = []
  end

  def login_form; end

  def login
    @auth.login(login_params[:email], login_params[:password])

    if @auth.jwt.blank?
      @login_errors = @auth.errors
      render :login_form
    else
      session[:jwt] = @auth.jwt
      redirect_to :index
    end
  end

  def register
    @auth.register(
      :lecturer_id => register_params[:lecturer_id],
      :student_id => register_params[:student_id],
      :email => register_params[:email],
      :password => register_params[:password],
      :password_confirmation => register_params[:password_confirmation]
    )

    if @auth.jwt.blank?
      @register_errors = @auth.errors
      render :login_form
    else
      session[:jwt] = @auth.jwt
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

    def register_params
      params.require(:user).permit(:lecturer_id, :student_id, :email, :password, :password_confirmation)
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
