class FaqsController < ApplicationController
  before_action :set_course_module, :set_coursework
  before_action :set_faq, only: [:edit, :update, :destroy]
  before_action do
    restrict_to_lecturer(@course_module.lecturer.lecturer_id)
  end

  def index
    @faqs = @coursework.faqs.all
  end

  def new
    @faq = @coursework.faqs.new
    @faq.course_module = @course_module
  end

  def edit
  end

  def create
    @faq = @coursework.faqs.new(faq_params)
    
    if @faq.save
      redirect_to(
        course_module_coursework_chatbot_faqs_url(:course_module_id => @course_module.id, :coursework_id => @coursework.id),
        notice: 'Faq was successfully created.'
      )
    else
      render :new
    end
  end

  def update
    if @faq.update_attributes(faq_params.merge(:coursework_id => @coursework.id))
      redirect_to(
        course_module_coursework_chatbot_faqs_url(:course_module_id => @course_module.id, :coursework_id => @coursework.id),
        notice: 'Faq was successfully updated.'
      )
    else
      render :edit
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

    def faq_params
      params.require(:faq).permit(:id, :question, :answer, :lecturer_id, :module_id, :coursework_id)
    end
end
