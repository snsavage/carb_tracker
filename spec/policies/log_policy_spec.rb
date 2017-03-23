require 'rails_helper'

RSpec.describe LogPolicy do
  subject { described_class.new(user, log) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Log.all).resolve
  end

  context 'with a user' do
    let(:user) { create(:user) }
    let(:log) { create(:log, user: user) }

    it { expect(resolved_scope).to include(log) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'with another user' do
    let(:user) { create(:user) }
    let(:log) { create(:log) }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }

    it 'excludes log from resolved scope' do
      expect(resolved_scope).not_to include(log)
    end
  end
end
