module Auth
  class RegistrationsController < ApplicationController
    def create
      user = User.new(signup_params)

      unless user.save
        return render json: { errors: user.errors.full_messages }, status: :unprocessable_content
      end

      tokens = generate_tokens(user)
      render json: {
        user: user_response(user),
        access_token: tokens[:access_token]
      }, status: :created
    end

    private

    def signup_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
  end
end
