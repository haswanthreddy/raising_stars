class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.belongs_to :resource, polymorphic: true, null: false
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :sessions, [:resource_type, :resource_id]
  end
end
