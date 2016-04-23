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
end