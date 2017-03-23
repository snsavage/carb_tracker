require 'rails_helper'

RSpec.describe RecipePolicy do
  subject { described_class.new(user, recipe) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Recipe.all).resolve
  end

  context 'with a user' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, user: user) }

    it { expect(resolved_scope).to include(recipe) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'with another user' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }

    it 'excludes recipe from resolved scope' do
      expect(resolved_scope).not_to include(recipe)
    end
  end

  context 'with public recipes' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, public: true) }

    it { expect(resolved_scope).to include(recipe) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end
end
