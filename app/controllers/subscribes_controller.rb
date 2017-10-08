class SubscribesController < ApplicationController

  def create
    user_id = params[:user_id]
    sub_id = params[:sub_id]
    user = User.find(user_id)
    if user.present?
      user.subscribes.create(sub_id: sub_id)
      head 200
    else
      head 404
    end
  end

  def unsubscribe
    user_id = params[:user_id]
    sub_id = params[:sub_id]
    subscription =  Subscribe.where(sub_id: sub_id, user_id: user_id).first
    if subscription.present?
      subscription.destroy
      head 200
    else
      head 404
    end
  end

end
