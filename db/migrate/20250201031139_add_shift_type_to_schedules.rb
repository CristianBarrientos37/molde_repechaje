class AddShiftTypeToSchedules < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :shift_type, :string
  end
end
