class CreateRetweets < ActiveRecord::Migration[5.0]
  def change
    create_table :retweets do |t|
      t.references :user, foreign_key: true
      t.integer :post_id

      t.timestamps
    end
  end
end
