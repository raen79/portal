class Auth
  include HTTParty
  base_uri ENV['AUTH_URL'] + '/api/authentication'

  def verify_token(jwt)
    @options = {
      :body => {
        :jwt => {
          :token => @jwt
        }
      }
    }

    self.class.put('/verify_token', options)
  end
end