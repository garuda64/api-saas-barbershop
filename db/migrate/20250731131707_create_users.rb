class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.string :id, primary_key: true, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :phone
      t.string :role, null: false, default: 'user'
      t.string :avatar
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
