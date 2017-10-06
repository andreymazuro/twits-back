class CreateSubscribes < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribes do |t|
      t.references :user, foreign_key: true
      t.integer :sub_id

      t.timestamps
    end
  end
end
