class CreateUserFollowsPivot < ActiveRecord::Migration
  def change
    create_table :user_follows, id: false do |t|
      t.integer :user_id, null: false
      t.integer :follower_id, null: false

      t.timestamps null: false
    end
    add_index :user_follows, :user_id
    add_index :user_follows, :follower_id
    add_index :user_follows, [:user_id, :follower_id], unique: true
  end
end
