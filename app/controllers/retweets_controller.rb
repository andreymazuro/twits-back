class RetweetsController < ApplicationController

  def create
    user_id = params[:user_id]
    post_id = params[:post_id]
    user = User.find(user_id)
    if user.present?
      user.retweets.create(post_id: post_id)
      head 200
    else
      head 400
    end
  end

end
