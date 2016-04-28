require 'rails_helper'

RSpec.describe 'routing to sessions' do
	it 'routes GET /login to sessions#new' do
		expect(get: '/login').to route_to(controller: 'sessions', action: 'new')		
	end	

	it 'routes POST /login to sessions#create' do
		expect(post: '/login').to route_to(controller: 'sessions', action: 'create')
	end
end