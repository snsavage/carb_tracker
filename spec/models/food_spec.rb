require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:food) { create(:food) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:ingredients) }
  it { is_expected.to have_many(:recipes).through(:ingredients) }

  it "has a unique unique_name" do
    create(:food)
    food_two = build(:food, user_id: User.first.id)

    expect(food_two).not_to be_valid
  end

  it { is_expected.to validate_presence_of(:food_name) }
  it { is_expected.to validate_presence_of(:serving_unit) }

  it {
    is_expected.to validate_numericality_of(:serving_qty).
    is_greater_than_or_equal_to(0)
  }

  it {
    is_expected.to validate_numericality_of(:calories).
    is_greater_than_or_equal_to(0)
  }

  it {
    is_expected.to validate_numericality_of(:total_fat).
    is_greater_than_or_equal_to(0)
  }

  it {
    is_expected.to validate_numericality_of(:total_carbohydrate).
    is_greater_than_or_equal_to(0)
  }

  it {
    is_expected.to validate_numericality_of(:protein).
    is_greater_than_or_equal_to(0)
  }

  it {
    is_expected.to validate_numericality_of(:saturated_fat).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:serving_weight_grams).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:cholesterol).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:sodium).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:dietary_fiber).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:sugars).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:potassium).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:ndb_no).
    is_greater_than_or_equal_to(0).allow_nil
  }

  it {
    is_expected.to validate_numericality_of(:tag_id).
    is_greater_than_or_equal_to(0).allow_nil
  }

  describe "#display" do
    it "creates a concatenated title for food" do
      expect(food.display).to eq("Apple - 1.0 - Medium (3\" Dia)")
    end
  end

  describe "#food_name=" do
    it "titleizes food_name" do
      food = create(:food, food_name: "apple_and_chocolate")
      expect(food.food_name).to eq("Apple And Chocolate")
    end
  end

  describe "#serving_unit=" do
    it "titleizes food_name" do
      food = create(:food, serving_unit: "apple_and_chocolate")
      expect(food.serving_unit).to eq("Apple And Chocolate")
    end
  end

  describe "#unique_name" do
    it "creates unique name for db storage" do
      expect(food.unique_name).to eq(
        "#{food.food_name} - #{food.serving_qty} - #{food.serving_unit}"
      )
    end
  end

  describe ".find_or_create_from_api" do
    context "with valid arguments" do
      let(:foods) { NutritionIx.new("1 apple").foods }
      let(:user) { create(:user) }

      it "creates a new food" do
        expect{
          Food.find_or_create_from_api(foods, user)
        }.to change{Food.all.count}.by(1)
      end

      it "returns an array of Food instances" do
        food = Food.find_or_create_from_api(foods, user).first
        expect(food).to be_an_instance_of(Food)
      end

      it "does not create duplicate foods" do
        first = Food.find_or_create_from_api(foods, user).first
        second = Food.find_or_create_from_api(foods, user).first

        expect(second.id).to eq(first.id)
        expect(Food.all.count).to eq(1)
      end
    end
  end
end
