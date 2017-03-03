FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.com" }
    password "password"
  end

  factory :recipe do
    name "apple"
  end

  factory :entry do
  end

  factory :food do
    sequence(:food_name) { |n| "apple #{n}" }
    serving_qty 1
    serving_unit "medium (3\" dia)"
    calories 10
    total_fat 10
    total_carbohydrate 10
    protein 10

    factory :user_food do
      user
    end

    factory :api_food do
      ndb_no 1003
    end
  end
end
