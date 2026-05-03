module Authenticatable
  extend ActiveSupport::Concern

  private

  def authenticate_user!
    payload = JwtService.decode(access_token)
    @current_user = User.find_by(public_id: payload["user_id"])
    render json: { error: "User not found" }, status: :unauthorized unless @current_user
  rescue JwtService::ExpiredToken
    render json: { error: "Token expired" }, status: :unauthorized
  rescue JwtService::InvalidToken
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def current_user
    @current_user
  end

  def access_token
    header = request.headers["Authorization"]
    header&.split(" ")&.last
  end

  def generate_tokens(user)
    refresh_token = user.refresh_tokens.create!
    set_refresh_token_cookie(refresh_token.token)

    { access_token: JwtService.encode(user) }
  end

  def set_refresh_token_cookie(token)
    cookies[:refresh_token] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: Rails.env.production? ? :none : :lax,
      expires: 30.days.from_now,
      path: "/auth"
    }
  end

  def clear_refresh_token_cookie
    cookies.delete(:refresh_token, path: "/auth")
  end

  def user_response(user)
    {
      public_id: user.public_id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      role: user.role
    }
  end
end
