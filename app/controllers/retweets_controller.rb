class RetweetsController < ApplicationController

  def create
    post_id = params[:post_id]
    if Post.exists?(id: post_id)
      @user.retweets.create(post_id: post_id)
      head 200
    else
      head 400
    end
  end

  def destroy
    post_id = params[:id]
    if Retweet.exists?(user_id: @user.id, post_id: post_id)
      Retweet.where(user_id: @user.id, post_id: post_id).first.destroy
    else
      head 404
    end
  end

end
