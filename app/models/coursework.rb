class Coursework < ApplicationRecord
  belongs_to :course_module
  delegate :lecturer, :to => :course_module

  validates :name, :uniqueness => true, :allow_nil => false, :presence => true

  def faqs
    Faqs.new(:coursework => self)
  end

  def code_marker(student:)
    @code_marker ||= CodeMarking.new(
      :coursework => self,
      :module => course_module,
      :lecturer => lecturer,
      :student => student
    )
  end

  def textual_marker(student: nil, jwt:)
    @textual_marker ||= TextualMarking.new(
      :coursework => self,
      :student => student,
      :jwt => jwt
    )
  end

  def code_marker(student: nil, jwt:)
    @code_marker ||= CodeMarking.new(
      :coursework => self,
      :student => student,
      :jwt => jwt
    )
  end
end
