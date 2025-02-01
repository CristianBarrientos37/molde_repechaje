class CreateEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :employees do |t|
      t.string :name
      t.date :birth_date
      t.string :position
      t.date :hire_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
