class Coursework < ApplicationRecord
  belongs_to :course_module
  delegate :lecturer, :to => :course_module

  def faqs
    Faqs.new(:coursework => self)
  end
end
