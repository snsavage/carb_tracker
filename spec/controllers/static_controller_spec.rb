require 'rails_helper'

describe StaticController, type: :controller do
  it { is_expected.to route(:get, '/').to(action: :index) }
end
