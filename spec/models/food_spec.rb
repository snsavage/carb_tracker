require 'rails_helper'

RSpec.describe Food, type: :model do
  it { is_expected.to have_many(:recipes_foods) }
  it { is_expected.to have_many(:recipes).through(:recipes_foods) }

  it "has a unique unique_name" do
    food_one = create(:food)
    food_two = build(:food)

    expect(food_two).not_to be_valid
  end

  describe "#display" do
  end

  describe ".search_form" do
    context "with valid arguments" do
      it "creates a new food" do
        expect{
          Food.search_form("1 apple")
        }.to change{Food.all.count}.by(1)
      end

      it "returns an array with a NutritionIx class and AR Food objects" do
        raise
      end
    end

    context "with line_delimited set to true and invalid input" do
      it "returns errors" do
        foods = Food.search_form("1 apple 1 banana", "true")
        expect(foods.errors?).to be true
      end
    end
  end
end
