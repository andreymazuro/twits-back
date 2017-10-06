class SubscribesController < ApplicationController

  def create
    user_id = params[:user_id]
    sub_id = params[:sub_id]
    @user = User.find(user_id)
    @user.subscribes.create(sub_id: sub_id)
    head 200
  end

  def destroy
    sub_id = params[:id]
    Subscribe.find(sub_id).destroy
    head 200
  end

end
