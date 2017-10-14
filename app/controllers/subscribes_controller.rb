class SubscribesController < ApplicationController

  def create
    sub_id = params[:sub_id]
    if @user.present? && sub_id != @user.id.to_s && User.exists?(id: sub_id)
      @user.subscribes.create(sub_id: sub_id)
      head 200
    else
      head 404
    end
  end

  def unsubscribe
    sub_id = params[:sub_id]
    subscription =  Subscribe.where(sub_id: sub_id, user_id: @user.id).first
    if subscription.present?
      subscription.destroy
      head 200
    else
      head 404
    end
  end

end
