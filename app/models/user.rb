class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :subscribes, dependent: :destroy
  has_many :retweets, dependent: :destroy
  EMAIL_REGEX = /@/
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  before_create :confirmation_token

  private

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end
