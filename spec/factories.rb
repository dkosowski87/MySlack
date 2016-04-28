FactoryGirl.define do	

	factory :team do
		name 'Founders'
		password 'welcome'
		password_confirmation 'welcome'
	end

	factory :user do
		name 'John'
		email 'john@example.com'
		password 'welcome'
		password_confirmation 'welcome'
		association :team
	end

	factory :team_member, class: User do
		name 'Jim'
		email 'jim@example.com'
		password 'welcome'
		password_confirmation 'welcome'
		association :team
	end

	factory :channel do
		name 'Fun'
		association :admin, factory: :user
		association :team
	end

end