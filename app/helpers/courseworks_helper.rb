module CourseworksHelper
  include ApplicationHelper

  def code_tests_present?(coursework)
    @code_tests ||= coursework.code_marker(:student => @current_user, :jwt => session[:jwt]).has_tests?
  end

  def code_solution_available?(coursework)
    @code_tests && !coursework.code_marker(:student => @current_user, :jwt => session[:jwt]).get_marked_solution.include?('errors')
  end

  def textual_solution_available?(coursework)
    !coursework.textual_marker(:student => @current_user, :jwt => session[:jwt]).get_marked_solution.include?('errors')
  end
end
