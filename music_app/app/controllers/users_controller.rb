class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            login!(@user)
            redirect_to cats_url
        else

        end
    end


    private 

    def user_params
        params.require(:user).permit(:email, :password, :session_token)
    end
end
