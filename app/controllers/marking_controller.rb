class MarkingController < ApplicationController
  before_action :restrict_to_students, :except => :submit_code_tests
  before_action :set_index, :set_breadcrumbs
  before_action :only => :submit_code_tests do
    restrict_to_lecturer(@course_module.lecturer.lecturer_id)
  end

  def submit_textual_solution
    response = @coursework.textual_marker(:student => @current_user, :jwt => get_jwt).submit_solution(file_params)

    if response.include?('errors')
      errors = response['errors']
      error_key = errors.keys.first
      error_messages = errors.values.first

      flash[:notice] = "Textual solution for #{@coursework.name} could not be submitted because #{error_key} #{error_messages.first}"
    else
      flash[:notice] = "Textual Solution for #{@coursework.name} has been submitted."
    end

    redirect_to course_module_coursework_path(:course_module_id => @course_module.id, :coursework_id => @coursework.id)
  end

  def submit_code_solution
    response = @coursework.code_marker(:student => @current_user, :jwt => get_jwt).submit_solution(file_params)

    if response.include?('errors')
      errors = response['errors']
      error_key = errors.keys.first
      error_messages = errors.values.first

      flash[:notice] = "Code solution for #{@coursework.name} could not be submitted because #{error_key} #{error_messages.first}"
    else
      flash[:notice] = "Code Solution for #{@coursework.name} has been submitted."
    end

    redirect_to course_module_coursework_path(:course_module_id => @course_module.id, :coursework_id => @coursework.id)
  end

  def submit_code_tests
    response = @coursework.code_marker(:jwt => get_jwt).submit_tests(file_params)

    if response.include?('errors')
      errors = response['errors']
      error_key = errors.keys.first
      error_messages = errors.values.first

      flash[:notice] = "Code tests for #{@coursework.name} could not be submitted because #{error_key} #{error_messages.first}"
    else
      flash[:notice] = "Code tests for #{@coursework.name} have been submitted."
    end

    redirect_to course_module_coursework_path(:course_module_id => @course_module.id, :coursework_id => @coursework.id)
  end

  def marked_code
    @marked_solution = @coursework.code_marker(:student => current_user, :jwt => get_jwt).get_marked_solution
  end

  def marked_text
    @marked_solution = @coursework.textual_marker(:student => current_user, :jwt => get_jwt).get_marked_solution
  end

  private
    def set_index
      @coursework = Coursework.find(params[:coursework_id])
      @course_module = CourseModule.find(params[:course_module_id])
      @courseworks = @course_module.courseworks.order(:name => :asc)
      @current_user = current_user
      @new_coursework = @course_module.courseworks.new
    end

    def set_breadcrumbs
      @breadcrumbs = [
        { :name => 'Modules', :url => course_modules_path },
        { :name => @course_module.name, :url => course_module_courseworks_path(:course_module_id => @course_module.id) },
        {
          :name => "#{@coursework.name} Marked Solution",
          :url => request.env['PATH_INFO']
        }
      ]
    end

    def file_params
      params.require(:solution)
    end
end
