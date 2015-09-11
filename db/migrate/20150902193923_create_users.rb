class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,     limit: 50
      t.string :surname,  limit: 50
      t.string :username, limit: 20, null: false
      t.string :email,               null: false

      t.timestamps null: false
    end

    add_index :users, :username,  unique: true
    add_index :users, :email,     unique: true
  end
end
