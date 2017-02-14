require 'rails_helper'

RSpec.describe Food, type: :model do
  it { is_expected.to have_many(:recipes_foods) }
  it { is_expected.to have_many(:recipes).through(:recipes_foods) }

  describe ".search_form" do
    context "with valid arguments" do
      it "creates a new food" do
        expect{
          Food.search_form("1 apple")
        }.to change{Food.all.count}.by(1)
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
