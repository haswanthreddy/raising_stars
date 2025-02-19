class CreateProgramActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :program_activities do |t|
      t.references :program, null: false
      t.references :activity, null: false
      t.integer :frequency
      t.integer :repetition
      t.timestamps
    end

    add_index :program_activities, [:program_id, :activity_id], unique: true
  end
end
