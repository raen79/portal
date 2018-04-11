class Auth
  include HTTParty
  base_uri ENV['AUTH_URL'] + '/api/authentication'

  def verify_token(jwt)
    @options = {
      :body => {
        'jwt' => {
          'token' => jwt
        }
      }
    }

    response = self.class.put('/verify_token', @options)
    
    if response.code == 200
      JSON.parse(response.body)['jwt']
    else
      nil
    end
  end

  def login(email, password)
    @options = {
      :body => {
        'login' => {
          'email' => email,
          'password' => password
        }
      }
    }

    response = self.class.post('/login', @options)
    if response.code == 200
      JSON.parse(response.body)['jwt']
    else
      nil
    end
  end

  def register(email:, password:, password_confirmation:, student_id:, lecturer_id:)
    @options = {
      :body => {
        'user' => {
          'email' => email,
          'password' => password,
          'password_confirmation' => password_confirmation
        }
      }
    }

    @options[:body]['user']['student_id'] = student_id unless student_id.blank?
    @options[:body]['user']['lecturer_id'] = lecturer_id unless lecturer_id.blank?

    response = self.class.post('/register', @options)
    
    if response.code == 201
      JSON.parse(response.body)['jwt']
    else
      nil
    end
  end
end