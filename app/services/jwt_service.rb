class JwtService
  SECRET_KEY = ENV.fetch("SECRET_KEY_BASE") { Rails.application.credentials.secret_key_base }
  ALGORITHM = "HS256"
  ISSUER = "padelicense-api"
  AUDIENCE = "padelicense-shop"
  ACCESS_TOKEN_EXPIRY = 15.minutes

  class ExpiredToken < StandardError; end
  class InvalidToken < StandardError; end

  def self.encode(user)
    payload = {
      user_id: user.public_id,
      exp: ACCESS_TOKEN_EXPIRY.from_now.to_i,
      iss: ISSUER,
      aud: AUDIENCE
    }
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true,
      algorithm: ALGORITHM,
      iss: ISSUER,
      aud: AUDIENCE,
      verify_iss: true,
      verify_aud: true
    )
    decoded.first
  rescue JWT::ExpiredSignature
    raise ExpiredToken
  rescue JWT::DecodeError
    raise InvalidToken
  end
end
