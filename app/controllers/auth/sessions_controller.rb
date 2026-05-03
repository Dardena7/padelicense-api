module Auth
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:email])

      if user&.valid_password?(params[:password])
        tokens = generate_tokens(user)
        render json: {
          user: user_response(user),
          access_token: tokens[:access_token]
        }
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    def destroy
      authenticate_user!
      return if performed?

      current_user.refresh_tokens.destroy_all
      clear_refresh_token_cookie
      render json: { message: "Logged out" }
    end
  end
end
