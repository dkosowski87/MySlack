require 'rails_helper'

RSpec.describe Team do

	context 'associations' do
		it { is_expected.to have_many(:users).dependent(:destroy) }
		it { is_expected.to have_many(:channels).dependent(:destroy) }
	end

	context 'validations' do
		it { is_expected.to have_secure_password }

		it do
			is_expected.to validate_presence_of(:name).
				with_message("Please state the name of your team.")
		end 

		it do
			is_expected.to validate_length_of(:name).
				is_at_least(3).
				is_at_most(15).
				with_message("The name of your team should be between 3-15 characters")
		end 

		it { is_expected.to allow_value('Founders 1').for(:name) }
		it { is_expected.not_to allow_value('Founders&#%').for(:name) }
	end

	context 'callbacks' do
		it 'should create a channel named "General" for the team after creating it' do
			team = create(:team)
			general_channel = team.channels.find_by(name: 'General')
			expect(general_channel).not_to be_nil
		end
	end

end