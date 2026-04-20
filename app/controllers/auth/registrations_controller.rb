module Auth
  class RegistrationsController < ApplicationController
    def create
      user = User.new(signup_params)

      if user.save
        tokens = generate_tokens(user)
        render json: {
          user: user_response(user),
          access_token: tokens[:access_token],
          refresh_token: tokens[:refresh_token]
        }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def signup_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
  end
end
