class CourseModule < ApplicationRecord
  has_many :courseworks

  validates :name, :uniqueness => true
  validates :lecturer_id, :presence => true, :allow_nil => false

  def lecturer
    @lecturer ||= User.find_by(:lecturer_id => lecturer_id)
  end

  def lecturer=(lecturer)
    @lecturer = lecturer
    @lecturer_id = lecturer.lecturer_id
  end
end
