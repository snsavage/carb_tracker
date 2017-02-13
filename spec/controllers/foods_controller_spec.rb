require 'rails_helper'

RSpec.describe FoodsController, type: :controller do
  describe "#search" do
    context "given search params" do
      before :each do
        request.env["HTTP_REFERER"] = new_food_url
      end

      it "gets new foods from api and saves to db" do
        expect{
          post :search, params: {search: "1 apple"}
        }.to change{Food.all.count}.by(1)
      end

      it "redirects to new_food_path" do
        expect(response).to redirect_to(new_food_path)
      end
    end
  end
end
