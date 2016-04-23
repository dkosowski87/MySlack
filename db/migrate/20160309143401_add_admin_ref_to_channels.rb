class AddAdminRefToChannels < ActiveRecord::Migration
  def change
    add_reference :channels, :admin, index: true
  end
end
