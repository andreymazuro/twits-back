class UsersController < ApplicationController

  def create
    @user = User.create(user_params)
    head 200
  end

  def destroy
    user_id = params[:id]
    @user = User.find(user_id)
    @user.destroy
    head 200
  end

  private
    def user_params
      params.permit(:username, :password, :fullname, :avatarurl)
    end

end
