class AddState < ActiveRecord::Migration
  def change
  	add_column :users, :state, :string
  	add_column :channels, :state, :string
  	add_column :msgs, :state, :string
  end
end
