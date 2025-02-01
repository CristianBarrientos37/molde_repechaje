class AddDetailsToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :phone, :string
    add_column :users, :user_type, :string, null: false, default: 'employee'
    add_column :users, :active, :boolean, default: true
    add_column :users, :last_login, :datetime
    
    add_index :users, :user_type
  end
end
