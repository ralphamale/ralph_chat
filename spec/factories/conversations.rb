FactoryGirl.define do
  factory :conversation do
    association :user1_id, factory: :user
    association :user2_id, factory: :user
  end
end
