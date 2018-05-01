class User
  attr_accessor :id, :email, :lecturer_id, :student_id

  def initialize(id:, email:, lecturer_id: nil, student_id: nil)
    @id = id
    @email = email
    @lecturer_id = lecturer_id
    @student_id = student_id
  end

  def faqs
    Faq.where(:lecturer_id => @lecturer_id)
  end

  def student?
    !@student_id.blank?
  end

  def lecturer?
    !@lecturer_id.blank?
  end

  def attributes
    {
      :id => id,
      :email => email,
      :lecturer_id => lecturer_id,
      :student_id => student_id
    }
  end

  def course_modules
    @course_modules ||= CourseModule.where(:lecturer_id => lecturer_id)
  end

  class << self
    private :new

    def find_by(lecturer_id: nil, email: nil, student_id: nil, jwt: nil)
      if !jwt.blank?
        initialize_from_hash(find_by_param(:jwt, jwt))
      elsif !student_id.blank?
        initialize_from_hash(find_by_param(:student_id, student_id))
      elsif !lecturer_id.blank?
        initialize_from_hash(find_by_param(:lecturer_id, lecturer_id))
      elsif !email.blank?
        initialize_from_hash(find_by_param(:email, email))
      end
    end

    def find(id)
      initialize_from_hash(find_by_param(:id, id))
    end

    private
      def initialize_from_hash(user_hash)
        unless user_hash.blank?
          new(
            :id => user_hash[:id],
            :email => user_hash[:email],
            :lecturer_id => user_hash[:lecturer_id],
            :student_id => user_hash[:student_id]
          )
        end
      end

      def find_by_param(param, value)
        response = HTTParty.get("#{ENV['AUTH_URL']}/api/users?#{param}=#{value}")

        if response.code == 200
          parsed_body = JSON.parse(response.body)
          parsed_body.extract!('id', 'email', 'lecturer_id', 'student_id').with_indifferent_access
        end
      end
  end
end
