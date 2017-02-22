FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.com" }
    password "password"
  end

  factory :recipe do
    name "apple"
  end


  factory :food do
    food_name "apple"
    serving_qty 1
    serving_unit "medium (3\" dia)"
    serving_weight_grams 182
    calories 10
    total_fat 10
    saturated_fat 10
    cholesterol 10
    sodium 10
    total_carbohydrate 10
    dietary_fiber 10
    sugars 10
    protein 10
    potassium 10
    ndb_no 9003
    tag_id 384
  end
end
