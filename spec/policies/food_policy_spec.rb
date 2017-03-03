require 'rails_helper'

RSpec.describe FoodPolicy do
  subject { described_class.new(user, food) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Food.all).resolve
  end

  context "without a user" do
    let(:user) { nil }
    let(:food) { nil }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "with a user provided food" do
    let(:user) { create(:user) }
    let(:food) { create(:food, user_id: user.id) }

    it { expect(resolved_scope).to include(food) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_action(:destroy) }
  end

  context "with another user" do
    let(:user) { create(:user) }
    let(:food) { create(:user_food) }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }

    it "excludes food from resolved scope" do
      expect(resolved_scope).not_to include(food)
    end
  end

  context "with a food from the api" do
    let(:user) { create(:user) }
    let(:food) { create(:api_food) }

    it { expect(resolved_scope).to include(food) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end
end
