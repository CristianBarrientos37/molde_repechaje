class AddOnDeleteToSchedules < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :schedules, :employees
    add_foreign_key :schedules, :employees, on_delete: :cascade
  end
end