FactoryGirl.define do
  factory :message do
  	association :author, factory: :user
    content { FFaker::Tweet.body }
    association :conversation, factory: :conversation
  end
end
