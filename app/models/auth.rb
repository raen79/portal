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
end