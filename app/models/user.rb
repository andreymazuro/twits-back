class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :subscribes, dependent: :destroy
  validates :username, uniqueness: true
end
