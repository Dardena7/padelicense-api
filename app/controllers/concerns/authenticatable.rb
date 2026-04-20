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
    {
      access_token: JwtService.encode(user),
      refresh_token: user.refresh_tokens.create!.token
    }
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
