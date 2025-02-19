class CreateUserActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_activities do |t|
      t.references :activity
      t.references :program
      t.timestamps
    end
  end
end
