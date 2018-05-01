class CourseModulesController < ApplicationController
  before_action :set_breadcrumbs
  before_action :set_course_module, :only => [:show, :update, :destroy]
  before_action :restrict_to_lecturer, :only => [:create]
  before_action :only => [:update, :destroy] do
    restrict_to_lecturer(@course_module.lecturer.lecturer_id)
  end

  def index
    @course_modules = CourseModule.order(:name => :asc)

    @new_course_module = CourseModule.new
    @new_course_module.lecturer = current_user
  end

  def show
  end

  def create
    @course_modules = CourseModule.order(:name => :asc)

    @new_course_module = CourseModule.new(course_module_params)
    @new_course_module.lecturer = current_user

    if @new_course_module.save
      redirect_to course_modules_url, notice: 'Module was successfully created.'
    else
      render :index
    end
  end

  def update
    if @course_module.update(course_module_params)
      redirect_to course_modules_url, notice: 'Module was successfully updated.'
    else
      @course_modules = CourseModule.order(:name => :asc).to_a
      @course_modules.map! do |course_module|
        if course_module.id == @course_module.id
          @course_module.name = course_module.name
          @course_module
        else
          course_module
        end
      end

      @new_course_module = CourseModule.new
      @new_course_module.lecturer = current_user

      render :index
    end
  end

  def destroy
    @course_module.destroy
    redirect_to course_modules_url, notice: 'Module was successfully destroyed.'
  end

  private
    def set_course_module
      if params[:id].blank?
        @course_module = current_user.course_modules.find(params[:course_module_id])
      elsif params[:course_module_id].blank?
        @course_module = current_user.course_modules.find(params[:id])
      end
    end

    def set_breadcrumbs
      @breadcrumbs = [
        { :name => 'Modules', :url => course_modules_path }
      ]
    end

    def course_module_params
      params.require(:course_module).permit(:name, :lecturer_id)
    end
end
