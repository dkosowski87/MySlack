class RemoveStateFromChannels < ActiveRecord::Migration
  def change
  	remove_column :channels, :state
  end
end
