class AddDetailsToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, limit: 50, null: false
    add_column :users, :phone, :string, limit: 50
  end
end
