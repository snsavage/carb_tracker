require 'rails_helper'

RSpec.describe Log, type: :model do
  it { is_expected.to have_many(:entries) }
  it { is_expected.to have_many(:recipes).through(:entries) }
end
