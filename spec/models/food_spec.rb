require 'rails_helper'

RSpec.describe Food, :vcr, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:ingredients) }
  it { is_expected.to have_many(:recipes).through(:ingredients) }

  describe 'user association' do
    context 'when a food in created from NutritionIx' do
      it 'should allow a food to be created without a user' do
        food = build(:api_food)
        expect(food).to be_valid
      end
    end

    context 'when a user creates a food' do
      it 'with a user the food is valid' do
        food = build(:user_food)
        expect(food).to be_valid
      end

      it 'without a user or ndb_no the food is invalid' do
        food = build(:user_food, user: nil)
        expect(food).to be_invalid
      end
    end

    it 'food cannot have both a user_id and a ndb_no' do
      food = build(:user_food, ndb_no: 100)
      expect(food).to be_invalid
    end
  end

  describe 'uniqueness validations' do
    context 'user created foods are unique per user' do
      it 'users can create foods with different unique_names' do
        food = create(:user_food)
        second_food = create(:user_food, user: food.user)
        expect(second_food).to be_valid
      end

      it 'users cannot create two foods with the same unique_name' do
        food = create(:user_food)
        dup_food = build(:user_food, food_name: food.food_name, user: food.user)
        expect(dup_food).not_to be_valid
      end

      it 'different users can create foods with the same unique_name' do
        food = create(:user_food)
        second_user = create(:user)

        dup_food = build(
          :user_food, food_name: food.food_name, user: second_user
        )

        expect(dup_food).to be_valid
      end
    end

    context 'NutritionIx foods are unique for all users' do
      it 'allows only one food from NutritionIx with the same unique_name' do
        food = create(:api_food)
        dup_food = build(:api_food, food_name: food.food_name)

        expect(food).to be_from_api
        expect(dup_food).to be_from_api
        expect(dup_food).not_to be_valid
      end
    end
  end

  it { is_expected.to validate_presence_of(:food_name) }
  it { is_expected.to validate_presence_of(:serving_unit) }

  it do
    is_expected.to validate_numericality_of(:serving_qty)
      .is_greater_than_or_equal_to(0)
  end

  it do
    is_expected.to validate_numericality_of(:calories)
      .is_greater_than_or_equal_to(0)
  end

  it do
    is_expected.to validate_numericality_of(:total_fat)
      .is_greater_than_or_equal_to(0)
  end

  it do
    is_expected.to validate_numericality_of(:total_carbohydrate)
      .is_greater_than_or_equal_to(0)
  end

  it do
    is_expected.to validate_numericality_of(:protein)
      .is_greater_than_or_equal_to(0)
  end

  it do
    is_expected.to validate_numericality_of(:saturated_fat)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:serving_weight_grams)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:cholesterol)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:sodium)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:dietary_fiber)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:sugars)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:potassium)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:ndb_no)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  it do
    is_expected.to validate_numericality_of(:tag_id)
      .is_greater_than_or_equal_to(0).allow_nil
  end

  describe '#food_name=' do
    it 'titleizes food_name' do
      food = build(:user_food, food_name: 'apple_and_chocolate')
      expect(food.food_name).to eq('Apple And Chocolate')
    end
  end

  describe '#serving_unit=' do
    it 'titleizes food_name' do
      food = build(:user_food, serving_unit: 'apple_and_chocolate')
      expect(food.serving_unit).to eq('Apple And Chocolate')
    end
  end

  describe '#unique_name' do
    it 'creates unique name for db storage' do
      food = create(:user_food)

      expect(food.unique_name).to eq(
        "#{food.food_name} - #{food.serving_qty} - #{food.serving_unit}"
      )
    end
  end

  describe '#from_api?' do
    context 'when food has a ndb_no' do
      it 'returns true' do
        expect(build(:api_food).from_api?).to be true
      end
    end

    context 'when food does not have a ndb_no' do
      it 'returns false' do
        expect(build(:user_food).from_api?).to be false
      end
    end
  end

  describe '.find_or_create_from_api' do
    context 'with valid arguments' do
      let(:foods) { NutritionIx.new('1 apple').foods }

      it 'creates a new food' do
        expect do
          Food.find_or_create_from_api(foods)
        end.to change { Food.all.count }.by(1)
      end

      it 'returns an array of Food instances' do
        food = Food.find_or_create_from_api(foods).first
        expect(food).to be_an_instance_of(Food)
      end

      it 'does not create duplicate foods' do
        first = Food.find_or_create_from_api(foods).first
        second = Food.find_or_create_from_api(foods).first

        expect(second.id).to eq(first.id)
        expect(Food.all.count).to eq(1)
      end
    end
  end
end
