require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it { is_expected.to belong_to(:recipe) }
  it { is_expected.to belong_to(:food) }
end
