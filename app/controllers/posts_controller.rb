class PostsController < ApplicationController

  def create
    user_id = params[:user_id]
    @user = User.find(user_id)
    post_content = params[:post_content]
    @user.posts.create(content: post_content)
    head 200
  end

  def destroy
    user_id = params[:user_id]
    post_id = params[:id]
    @user = User.find(user_id)
    @user.posts.find(post_id).destroy
    head 200
  end

end
