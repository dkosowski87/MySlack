class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.text :content, limit: 2000
  		t.references :user, index: true
      t.timestamps null: false
    end
  end
end
