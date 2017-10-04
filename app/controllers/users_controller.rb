class UsersController < ApplicationController

  def create
    @user = User.create(user_params)
    head 200
  end

  private
    def user_params
      params.permit(:username, :password, :fullName, :avatarUrl)
    end

end
