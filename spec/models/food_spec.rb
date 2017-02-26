require 'rails_helper'

RSpec.describe Food, type: :model do
  it { is_expected.to have_many(:ingredients) }
  it { is_expected.to have_many(:recipes).through(:ingredients) }

  it "has a unique unique_name" do
    food_one = create(:food)
    food_two = build(:food)

    expect(food_two).not_to be_valid
  end

  describe "#display" do
    it "creates a concatenated title for food" do
      food = create(:food)

      expect(food.display).to eq("Apple - 1.0 - medium (3\" dia)")
    end
  end

  describe "#get_unique_name" do
    it "creates unique name for db storage" do
      food = create(:food)

      expect(food.get_unique_name).to eq(food.unique_name)
    end
  end

  describe ".find_or_create_from_api" do
    context "with valid arguments" do
      let(:foods) { NutritionIx.new("1 apple").foods }

      it "creates a new food" do
        expect{
          Food.find_or_create_from_api(foods)
        }.to change{Food.all.count}.by(1)
      end

      it "returns an array of Food instances" do
        food = Food.find_or_create_from_api(foods).first
        expect(food).to be_an_instance_of(Food)
      end

      it "does not create duplicate foods" do
        first = Food.find_or_create_from_api(foods).first
        second = Food.find_or_create_from_api(foods).first

        expect(second.id).to eq(first.id)
        expect(Food.all.count).to eq(1)
      end
    end
  end
end
