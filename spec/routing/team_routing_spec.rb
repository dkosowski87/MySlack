require 'rails_helper'

RSpec.describe 'routing to teams' do

	it 'routes GET "root" to teams#new' do
		expect(get: '/').to route_to(controller: 'teams', action: 'new')
	end

	it 'routes GET "/teams/new" to teams#new' do
		expect(get: '/teams/new').to route_to(controller: 'teams', action: 'new')
	end

	it 'routes POST "/teams" to teams#create' do
		expect(post: '/teams').to route_to(controller: 'teams', action: 'create')
	end

	it 'routes POST "/teams/join" to teams#join' do
		expect(post: '/teams/join').to route_to(controller: 'teams', action: 'join')
	end
	
end