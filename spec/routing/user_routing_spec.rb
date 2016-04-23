require 'rails_helper'

RSpec.describe 'routing to users' do
	it 'routes GET "/teams/:team_id/users/new" to users#new' do
		expect(get: '/teams/1/users/new').to route_to(controller: 'users', action: 'new', team_id: '1')
	end

	it 'routes POST "/teams/:team_id/users" to users#create' do
		expect(post: '/teams/1/users').to route_to(controller: 'users', action: 'create', team_id: '1')
	end
end