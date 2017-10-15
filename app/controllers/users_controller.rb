class UsersController < ApplicationController
  skip_before_action :request_token, :only => [:create, :sign_in]

  def create
    user = User.new(
      username: params[:username],
      email: params[:email],
      hashed_password: hash_password(params[:password]),
      avatarurl: params[:avatarurl],
      fullname: params[:fullname]
    )

    ApplicationMailer.send_signup_email(user).deliver

    if user.save
      head 200
    else
      render json: user.errors.messages, status: 404
    end
  end

  def sign_in
    user = User.find { |u| u.email == params[:email] }
    if user && test_password(params[:password], user.hashed_password)
      token = SecureRandom.hex(10)
      $redis.set(token, user.id)
      render json: {token: token, user: user}
    else
      render json:  {error: 'Email or password was incorrect'}, status: 404
    end
  end

  def get_user
    render json: {user: @user}
  end

  def destroy
    if @user.present?
      @user.destroy
      head 200
    else
      head 404
    end
  end

  private

    def confirmation_token
      if self.confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end

    def hash_password(password)
      BCrypt::Password.create(password).to_s
    end

    def test_password(password, hash)
      BCrypt::Password.new(hash) == password
    end

end
