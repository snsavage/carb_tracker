require 'rails_helper'

RSpec.describe NutritionIx, :vcr, type: :model do
  let(:nutrition_ix) { NutritionIx.new('apple', true) }

  it 'initializes with search and line_delimited' do
    expect(nutrition_ix).to be_an_instance_of(NutritionIx)
    expect(nutrition_ix.search).to eq('apple')
    expect(nutrition_ix.line_delimited).to eq(true)
  end

  describe '#food' do
    it 'can be called again after first call' do
      nutrition_ix.foods
      expect { nutrition_ix.foods }.not_to raise_error
    end

    context 'api returns errors' do
      it 'returns an empty array' do
        nutrition_ix.search = ''
        expect(nutrition_ix.foods).to eq([])
      end
    end
  end

  describe '#reload!' do
    it 'refreshes data with new api call' do
      first_food = nutrition_ix.foods.first[:food_name]

      nutrition_ix.search = 'carrot'
      nutrition_ix.reload!
      second_food = nutrition_ix.foods.first[:food_name]

      expect(second_food).not_to eq(first_food)
      expect(second_food).to eq('carrot')
    end
  end

  describe '#errors? and #messages' do
    context 'with no search term' do
      it 'returns true' do
        nutrition_ix.search = 'xyz'
        nutrition_ix.reload!

        message = 'We couldn\'t match any of your foods'

        expect(nutrition_ix.errors?).to be true
        expect(nutrition_ix.messages).to eq(message)
      end
    end

    context 'with a valid search term' do
      it 'returns false' do
        message = 'Your search was successful!'

        expect(nutrition_ix.errors?).to be false
        expect(nutrition_ix.messages).to eq(message)
      end
    end
  end

  describe '#foods' do
    context 'with one food' do
      it 'returns one food' do
        expect(nutrition_ix.foods.count).to eq(1)
        expect(nutrition_ix.foods.first[:food_name]).to eq('apple')
      end
    end

    context 'with two line delimited foods' do
      it 'returns two foods' do
        nutrition_ix.search = "1 apple \n 1 banana"
        nutrition_ix.reload!

        expect(nutrition_ix.foods.count).to eq(2)
        expect(nutrition_ix.foods.first[:food_name]).to eq('apple')
        expect(nutrition_ix.foods.last[:food_name]).to eq('banana')
      end
    end

    context 'with two foods on the same line' do
      it 'returns two foods' do
        nutrition_ix.search = '1 apple and 1 banana'
        nutrition_ix.line_delimited = false
        nutrition_ix.reload!

        expect(nutrition_ix.foods.count).to eq(2)
        expect(nutrition_ix.foods.first[:food_name]).to eq('apple')
        expect(nutrition_ix.foods.last[:food_name]).to eq('banana')
      end
    end
  end
end
