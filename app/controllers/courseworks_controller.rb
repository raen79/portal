class CourseworksController < ApplicationController
  before_action :set_course_module
  before_action :set_coursework, :only => [:edit, :update, :destroy]
  before_action :except => :index do
    restrict_to_lecturer(@course_module.lecturer.lecturer_id)
  end

  def index
    @courseworks = @course_module.courseworks
    @current_user = current_user
  end

  def new
    @coursework = @course_module.courseworks.new
  end

  def edit
  end

  def create
    @coursework = @course_module.courseworks.new(coursework_params)

    if @coursework.save
      redirect_to course_module_courseworks_url(:course_module_id => @course_module.id), notice: 'Coursework was successfully created.'
    else
      render :new
    end
  end

  def update
    if @coursework.update(coursework_params)
      redirect_to course_module_courseworks_url(:course_module_id => @course_module.id), notice: 'Coursework was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @coursework.destroy
    redirect_to course_module_courseworks_url(:course_module_id => @course_module.id), notice: 'Coursework was successfully destroyed.'
  end

  private
    def set_course_module
      @course_module = CourseModule.find(params[:course_module_id])
    end

    def set_coursework
      @coursework = @course_module.courseworks.find(params[:id])
    end

    def coursework_params
      params.require(:coursework).permit(:name, :module_id)
    end
end
