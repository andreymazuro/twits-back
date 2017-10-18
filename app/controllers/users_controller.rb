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

    if params[:password].length > 7 && user.save
      ApplicationMailer.send_signup_email(user).deliver
      render json: {response: 'success'}, status: 200
    else
      user.errors.messages[:password] = ['Password is too short. Minimum 8 characters']
      render json: {error: user.errors.messages} , status: 404
    end

  end

  def sign_in
    user = User.find { |u| u.email == params[:email] }

    if user.nil?
      render json: {error: {email: 'Email is not registered'} }, status: 401
    end

    if user.present? && !test_password(params[:password], user.hashed_password)
      render json: {error: {password: 'Password was incorrect'} }, status: 401
    end

    if user && test_password(params[:password], user.hashed_password) && user.email_confirmed
      token = SecureRandom.hex(10)
      $redis.set(token, user.id)
      render json: {token: token, user: user}, status: 200
    elsif user && test_password(params[:password], user.hashed_password) && !user.email_confirmed
      render json:  {error: {activation: 'Activate your account please, confirmation link was send to email'} }, status: 401
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
