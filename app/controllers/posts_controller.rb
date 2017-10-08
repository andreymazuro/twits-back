class PostsController < ApplicationController

  def create
    user_id = params[:user_id]
    post_content = params[:post_content]
    user = User.find(user_id)
    if user.present?
      user.posts.create(content: post_content)
      head 200
    else
      head 404
    end
  end

  def destroy
    post_id = params[:id]
    post = Post.find(post_id)
    if post.present?
      post.destroy
      head 200
    else
      head 404
    end
  end

end
