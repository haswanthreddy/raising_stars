class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.references :admin
      t.string :name, null: false
      t.string :description
      t.integer :category, null: false
      t.integer :frequency, null: false
      t.integer :repetition, null: false
      t.timestamps
    end

    add_index :activities, :name, unique: true
  end
end
