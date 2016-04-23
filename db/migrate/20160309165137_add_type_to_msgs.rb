class AddTypeToMsgs < ActiveRecord::Migration
  def change
    add_column :msgs, :type, :string
  end
end
