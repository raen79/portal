class FaqsController < ApplicationController
  before_action :set_course_module, :set_coursework, :set_breadcrumbs
  before_action :set_faq, only: [:update, :destroy]
  before_action do
    restrict_to_lecturer(@course_module.lecturer.lecturer_id)
  end

  def index
    @faqs = @coursework.faqs.all
    @current_user = current_user
    @new_faq = @coursework.faqs.new
  end

  def create
    @faqs = @coursework.faqs.all
    @faq = @coursework.faqs.new(faq_params)
    @new_faq = @coursework.faqs.new
    
    if @faq.save
      redirect_to(
        course_module_coursework_chatbot_faqs_url(:course_module_id => @course_module.id, :coursework_id => @coursework.id),
        :notice => 'Faq was successfully created.'
      )
    else
      render :index
    end
  end

  def update
    if @faq.update_attributes(faq_params.merge(:coursework_id => @coursework.id))
      redirect_to(
        course_module_coursework_chatbot_faqs_url(:course_module_id => @course_module.id, :coursework_id => @coursework.id),
        notice: 'Faq was successfully updated.'
      )
    else
      @new_faq = @coursework.faqs.new

      @faqs = @coursework.faqs.all.to_a
      @faqs.map! do |faq|
        if @faq.id == faq.id
          @faq.question = faq.question
          @faq.answer = faq.answer
          @faq.coursework = faq.coursework
          @faq
        else
          faq
        end
      end

      render :index
    end
  end

  def destroy
    @faq.destroy
    redirect_to(
      course_module_coursework_chatbot_faqs_url(:course_module_id => @course_module.id, :coursework_id => @coursework.id),
      notice: 'Faq was successfully destroyed.'
    )
  end

  private
    def set_course_module
      @course_module = CourseModule.find(params[:course_module_id])
    end

    def set_coursework
      @coursework = @course_module.courseworks.find(params[:coursework_id])
    end

    def set_faq
      @faq = @coursework.faqs.find(params[:id])
    end

    def set_breadcrumbs
      @breadcrumbs = [
        { :name => 'Course Modules', :url => course_modules_path },
        { :name => @course_module.name, :url => course_module_courseworks_path(:course_module_id => @course_module.id) },
        {
          :name => @coursework.name,
          :url => course_module_coursework_chatbot_faqs_path(:course_module_id => @course_module.id, :coursework_id => @coursework.id)
        }
      ]
    end

    def faq_params
      params.require(:faq).permit(:id, :question, :answer, :lecturer_id, :module_id, :coursework_id)
    end
end
