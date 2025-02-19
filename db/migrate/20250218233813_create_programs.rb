class CreatePrograms < ActiveRecord::Migration[8.0]
  def change
    create_table :programs do |t|
      t.references :admin
      t.references :user
      t.string :title
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
