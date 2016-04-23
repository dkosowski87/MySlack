class ChangeMsgsTable < ActiveRecord::Migration
  def change
  	change_table :msgs do |t|
  		t.rename :user_id, :sender_id
  		t.references :recipient, polymorphic: true, index: true
  	end
  end
end
