class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :users, index: true
  end
end
