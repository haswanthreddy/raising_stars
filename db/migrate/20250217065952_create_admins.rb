class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :full_name, null: false
      t.string :email_address, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :admins, :email_address, unique: true
  end
end
