class Coursework < ApplicationRecord
  belongs_to :course_module
  delegate :lecturer, :to => :course_module

  validates :name, :uniqueness => true, :allow_nil => false, :presence => true

  def faqs
    Faqs.new(:coursework => self)
  end
end
