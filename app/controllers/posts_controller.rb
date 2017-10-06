class PostsController < ApplicationController

  def create
    user_id = params[:user_id]
    @user = User.find(user_id)
    post_content = params[:post_content]
    @user.posts.create(content: post_content)
    head 200
  end

  def destroy
    post_id = params[:id]
    @post = Post.find(post_id)
    @post.destroy
    head 200
  end

end
