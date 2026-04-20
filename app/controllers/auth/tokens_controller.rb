module Auth
  class TokensController < ApplicationController
    def refresh
      refresh_token = RefreshToken.find_by(token: params[:refresh_token])

      if refresh_token.nil?
        return render json: { error: "Invalid refresh token" }, status: :unauthorized
      end

      if refresh_token.expired?
        refresh_token.destroy
        return render json: { error: "Refresh token expired" }, status: :unauthorized
      end

      user = refresh_token.user
      refresh_token.destroy
      new_tokens = generate_tokens(user)

      render json: {
        access_token: new_tokens[:access_token],
        refresh_token: new_tokens[:refresh_token]
      }
    end
  end
end
