class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base
  ALGORITHM = "HS256"
  ACCESS_TOKEN_EXPIRY = 15.minutes

  class ExpiredToken < StandardError; end
  class InvalidToken < StandardError; end

  def self.encode(user)
    payload = {
      user_id: user.public_id,
      exp: ACCESS_TOKEN_EXPIRY.from_now.to_i
    }
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)
    decoded.first
  rescue JWT::ExpiredSignature
    raise ExpiredToken
  rescue JWT::DecodeError
    raise InvalidToken
  end
end
