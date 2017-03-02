require 'rails_helper'

RSpec.describe Food, type: :model do
  it { is_expected.to have_many(:ingredients) }
  it { is_expected.to have_many(:recipes).through(:ingredients) }

  it "has a unique unique_name" do
    user = create(:user)
    food_one = create(:food, user_id: user.id)
    food_two = build(:food, user_id: user.id)

    expect(food_two).not_to be_valid
  end

  describe "#display" do
    it "creates a concatenated title for food" do
      user = create(:user)
      food = create(:food, user_id: user.id)

      expect(food.display).to eq("Apple - 1.0 - Medium (3\" Dia)")
    end
  end

  describe "#get_unique_name" do
    it "creates unique name for db storage" do
      user = create(:user)
      food = create(:food, user_id: user.id)

      expect(food.get_unique_name).to eq(food.unique_name)
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
