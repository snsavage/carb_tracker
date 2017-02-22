require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { is_expected.to have_many(:recipes_foods) }
  it { is_expected.to have_many(:foods).through(:recipes_foods) }

  it { is_expected.to have_many(:entries) }
  it { is_expected.to have_many(:logs).through(:entries) }
end
