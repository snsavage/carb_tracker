FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.com" }
    password 'password'
  end

  factory :log do
    log_date Date.current
    user

    transient do
      recipe_count 1
    end

    after(:build) do |log, evaluator|
      evaluator.recipe_count.times do
        log.recipes << build(:recipe)
      end
    end
  end

  factory :recipe do
    sequence(:name) { |n| "apple #{n}" }
    user

    transient do
      food_count 1
    end

    after(:build) do |recipe, evaluator|
      evaluator.food_count.times do
        recipe.foods << build(:api_food)
      end
    end
  end

  factory :api_food, class: :food do
    sequence(:food_name) { |n| "apple #{n}" }
    serving_qty 1
    serving_unit "medium (3\" dia)"
    calories 10
    total_fat 10
    total_carbohydrate 10
    protein 10
    ndb_no 1003

    factory :user_food do
      ndb_no nil
      user
    end
  end
end
