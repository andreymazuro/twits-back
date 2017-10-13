class ApplicationController < ActionController::API
  before_action :request_token

  private

  def request_token
    token = request.headers[:token]
    id = $redis.get(token)
    if id.nil?
      head 404
    else
      @user = User.find(id)
    end
  end
end
