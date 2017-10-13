class PostsController < ApplicationController
  skip_before_action :request_token, :only => [:generate_user_wall]

  def destroy
    post_id = params[:id]
    post = Post.exists?(id: post_id) && Post.find(post_id)
    if post.present? && post.user_id == @user.id
      post.destroy
      head 200
    else
      head 404
    end
  end

  def generate_feed
    if @user.present?
      feed = @user.subscribes.map { |subscribe| User.find(subscribe.sub_id).posts }.flatten
      sorted_feed = organize_post_data(feed.sort_by { |post| post.created_at }.reverse!)
      feed_with_formatted_time = sorted_feed.each{ |post| post[:created_at] = post[:created_at].strftime("%b %d") }
      render json: feed_with_formatted_time
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
      posts = organize_post_data(user.posts)
      sorted_feed = (posts + retweets).sort_by { |post| post[:created_at] }.reverse!
      feed_with_formatted_time = sorted_feed.each { |post| post[:created_at] = post[:created_at].strftime("%b %d") }
      render json: feed_with_formatted_time
    else
      head 404
    end
  end

  private
    def organize_post_data(posts)
      posts.map{ |post| {
                   content: post.content,
                   created_at: post.created_at,
                   post_id: post.id,
                   user: User.find(post.user_id)
                 } }
    end

end
