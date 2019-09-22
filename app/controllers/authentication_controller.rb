class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login
    def login
        @user = User.find_by_email(params[:email])
        if@user&.authenticate(params[:password])
            token = Auth.encode(user_id: @user.id)
            time = Time.now + 24.hours.to_i
            render json: {token: token, expire: time.strftime("%d-%m-%Y %H:%M"), user: @user}, status: :ok
        else
            render json: {error: 'Unauthorized'}, status: :unauthorized
        end
    end
    private
    def login_parms 
        params.permit(:email, :password)
    end
end
