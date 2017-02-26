require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { is_expected.to have_many(:ingredients) }
  it { is_expected.to have_many(:foods).through(:ingredients) }

  it { is_expected.to have_many(:entries) }
  it { is_expected.to have_many(:logs).through(:entries) }
end
