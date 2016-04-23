class AddNumberOfMembersToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :number_of_members, :integer
  end
end
