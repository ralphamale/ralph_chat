FactoryGirl.define do
  factory :user do
		password '12345ab'
		password_confirmation '12345ab'
		email { FFaker::Internet.unique.email }
  end
end