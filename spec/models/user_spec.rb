require 'rails_helper'

RSpec.describe User do

	context 'associations' do
		it do is_expected.to belong_to(:team).
			counter_cache(:number_of_members) end
		
		it do is_expected.to have_many(:adm_channels).
			class_name('Channel').
			with_foreign_key(:admin_id) 
		end

		it { is_expected.to have_and_belong_to_many(:channels)}

		it do
			is_expected.to have_many(:sent_msgs).
			class_name('Msg').
			with_foreign_key(:sender_id)
		end

		it do
			is_expected.to have_many(:received_msgs).
			conditions(:readonly).
			class_name('Msg')
		end

		it do
			is_expected.to have_many(:sent_invitations).
			conditions(recipient_type: 'User').
			class_name('Invitation').
			with_foreign_key(:sender_id)
		end

		it do
			is_expected.to have_many(:received_invitations).
			conditions(:readonly).
			class_name('Invitation')
		end
	end
	
	context 'validations' do
		it { is_expected.to have_secure_password }
		
		it { is_expected.to validate_presence_of(:name).with_message("Please state your name.") }
		it { is_expected.to allow_value('John').for(:name) }
		it { is_expected.not_to allow_value('john').for(:name)}

		it { is_expected.to validate_presence_of(:team_id) }

		it { is_expected.to validate_presence_of(:email).with_message("Please enter your email.") }
		it { is_expected.to allow_value('john@example.com').for(:email) }
		it { is_expected.not_to allow_value('johnexample.com').for(:email)}

		subject { build(:user) }
		it { is_expected.to validate_uniqueness_of(:email).
			case_insensitive.
			with_message("This email has already been taken.") }
	end

	context 'callbacks' do
		it 'should send a welcome message after creation' do
			team = create(:team)
			user = create(:user, team_id: team.id)
			team_member = create(:user, email: 'james@example.com', team_id: team.id)
			expect(Msg.where(recipient_type: 'User').count).to eq(1)
			expect(Msg.where(recipient_type: 'User').first.content).to match(/joined your team/)
			expect(user.received_msgs.count).to eq(1)
		end

		it 'is expected to join the teams "General" channel after creation' do
			user = create(:user)
			expect(Channel.first.users.first.id).to eq(user.id)
		end
	end
		
end