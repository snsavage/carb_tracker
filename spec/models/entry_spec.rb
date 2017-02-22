require 'rails_helper'

RSpec.describe Entry, type: :model do
  it { is_expected.to belong_to(:log) }
  it { is_expected.to belong_to(:recipe) }
end
