class CourseModulesController < ApplicationController
  before_action :set_course_module, :only => [:edit, :update, :destroy]
  before_action :restrict_to_lecturer, :only => [:create]
  before_action :only => [:edit, :update, :destroy] do
    restrict_to_lecturer(@course_module.lecturer.lecturer_id)
  end

  def index
    @course_modules = current_user.course_modules.order(:name => :asc)

    @new_course_module = CourseModule.new
    @new_course_module.lecturer = current_user
  end

  def create
    @course_modules = current_user.course_modules.order(:name => :asc)

    @new_course_module = CourseModule.new(course_module_params)
    @new_course_module.lecturer = current_user

    if @new_course_module.save
      redirect_to course_modules_url, notice: 'Course module was successfully created.'
    else
      render :index
    end
  end

  def update
    if @course_module.update(course_module_params)
      redirect_to course_modules_url, notice: 'Course module was successfully updated.'
    else
      @course_modules = current_user.course_modules.order(:name => :asc).to_a
      @course_modules.map! do |course_module|
        if course_module.id == @course_module.id
          @course_module.name = course_module.name
          @course_module
        else
          course_module
        end
      end

      @new_course_module = CourseModule.new(course_module_params)
      @new_course_module.lecturer = current_user

      render :index
    end
  end

  def destroy
    @course_module.destroy
    redirect_to course_modules_url, notice: 'Course module was successfully destroyed.'
  end

  private
    def set_course_module
      @course_module = current_user.course_modules.find(params[:id])
    end

    def course_module_params
      params.require(:course_module).permit(:name, :lecturer_id)
    end
end
