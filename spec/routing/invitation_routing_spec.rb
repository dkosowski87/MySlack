require 'rails_helper'

RSpec.describe 'routing to invitations' do
	it 'routes GET invitations/new to invitations#new' do
		expect(get: 'invitations/new').to route_to(controller: 'invitations', action: 'new')
	end
	it 'routes POST invitations to invitations#create' do
		expect(post: 'invitations').to route_to(controller: 'invitations', action: 'create')
	end
end