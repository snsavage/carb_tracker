require 'rails_helper'

RSpec.describe FoodsController, :vcr, type: :controller do
  describe '#search' do
    before(:each) do
      user = create(:user)
      sign_in user
    end

    context 'with valid search terms' do
      it 'should return foods in json' do
        get :search, params: {query: "1 apple"}

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["foods"].length).to eq(1)
      end

      it 'should return multiple foods' do
        get :search, params: {query: "1 apple \n 1 banana"}

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(2)
      end

      it 'should add new foods to database' do
        expect{
          get :search, params: {query: "1 apple \n 1 banana"}
        }.to change{Food.count}.by(2)
      end

      it 'should not add existing foods to database' do
        Food.create(NutritionIx.new('1 apple').foods)

        expect{
          get :search, params: {query: "1 apple"}
        }.not_to change{Food.count}

        expect{
          get :search, params: {query: "1 banana"}
        }.to change{Food.count}.by(1)
      end
    end

    context 'with an invalid search' do
      it 'returns an error message' do
        get :search, params: {query: ''}

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq(t('food.search.error'))
      end
    end
  end
end
