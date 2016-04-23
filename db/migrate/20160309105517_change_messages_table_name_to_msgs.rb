class ChangeMessagesTableNameToMsgs < ActiveRecord::Migration
  def change
  	rename_table :messages, :msgs
  end
end
