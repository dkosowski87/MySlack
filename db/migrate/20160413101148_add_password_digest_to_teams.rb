class AddPasswordDigestToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :password_digest, :string
    add_index :teams, :password_digest
  end
end
