class UsersController < ApplicationController
  skip_before_action :request_token, :only => [:create, :sign_in, :activate_account]

  def create
    user = User.new(
      username: params[:username],
      email: params[:email],
      hashed_password: hash_password(params[:password]),
      avatarurl: params[:avatarurl],
      fullname: params[:fullname]
    )

    err = Hash.new

    if User.exists?(username: user.username)
      old_user = User.where(username: user.username).first
      if old_user.email_confirmed || check_if_activation_time_not_expired(old_user)
        err[:username_taken] = true
      end
    end

    if User.exists?(email: user.email)
      old_user = User.where(email: user.email).first
      if old_user.email_confirmed || check_if_activation_time_not_expired(old_user)
        err[:email_taken] = true
      end
    end

    if err.empty? && user.save
      ApplicationMailer.send_signup_email(user).deliver
      head 200
    else
      render json: err, status: 404
    end
  end

  def sign_in
    user = User.find { |u| u.email == params[:email] }
    if user && test_password(params[:password], user.hashed_password) && user.email_confirmed
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

  def activate_account
    token = params[:token]
    user = User.where(confirm_token: token).first
    if user.present?
      user.update(email_confirmed: true)
    end
  end

  private

    def check_if_activation_time_not_expired(user)
      not_expired = Time.now - user.created_at < 86400
      if !not_expired
        user.destroy
      end
      not_expired
    end

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
