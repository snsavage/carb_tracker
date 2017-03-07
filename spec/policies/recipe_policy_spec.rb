require 'rails_helper'

RSpec.describe RecipePolicy do
  subject { described_class.new(user, recipe) }

  context "with a user" do
    let(:user) { create(:user) }

  end
end
