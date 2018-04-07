class CourseworksController < ApplicationController
  before_action :set_course_module
  before_action :set_coursework, :only => [:edit, :update, :destroy]
  before_action :except => :index do
    restrict_to_lecturer(@course_module.lecturer.lecturer_id)
  end

  def index
    @courseworks = @course_module.courseworks.order(:name => :asc)
    @current_user = current_user

    @new_coursework = @course_module.courseworks.new
  end

  def create
    @courseworks = @course_module.courseworks.order(:name => :asc)
    @new_coursework = @course_module.courseworks.new(coursework_params)

    if @new_coursework.save
      redirect_to course_module_courseworks_url(:course_module_id => @course_module.id), notice: 'Coursework was successfully created.'
    else
      render :index
    end
  end

  def update
    if @coursework.update(coursework_params)
      redirect_to course_module_courseworks_url(:course_module_id => @course_module.id), notice: 'Coursework was successfully updated.'
    else
      @new_coursework = @course_module.courseworks.new(coursework_params)
      
      @courseworks = @course_module.courseworks.order(:name => :asc).to_a
      @courseworks.map! do |coursework|
        if coursework.id == @coursework.id
          @coursework.name = coursework.name
          @coursework
        else
          coursework
        end
      end

      render :index
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
