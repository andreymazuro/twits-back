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

  def generate_feed
    user_id = params[:id]
    user = User.find(user_id)
    if user.present?
      feed = user.subscribes.map { |subscribe| User.find(subscribe.sub_id).posts }.flatten
      render json: feed
    else
      head 404
    end
  end

  def generate_user_wall
    username = params[:username]
    user = User.where(username: username).first
    if user.present?
      retweets = user.retweets.map do |retweet|
        @post = Post.find(retweet.post_id)
        {
          content: @post.content,
          created_at: retweet.created_at,
          post_id: @post.id,
          user: User.find(@post.user_id)
        }
      end
      posts = user.posts.map{ |post| {
                                content: post.content,
                                created_at: post.created_at,
                                post_id: post.id,
                                user: User.find(post.user_id)
                              } }
      sorted_feed = (posts + retweets).sort_by { |post| post[:created_at] }.reverse!
      feed_with_formatted_time = sorted_feed.each { |post| post[:created_at] = post[:created_at].strftime("%b %d") }
      render json: feed_with_formatted_time
    else
      head 404
    end
  end

end
