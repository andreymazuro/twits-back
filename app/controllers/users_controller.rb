class UsersController < ApplicationController

  def create
    User.create(user_params)
    head 200
  end

  def destroy
    user_id = params[:id]
    user = User.find(user_id)
    if user.present?
      user.destroy
      head 200
    else
      head 404
    end
  end

  private
    def user_params
      params.permit(:username, :password, :fullname, :avatarurl)
    end

end
