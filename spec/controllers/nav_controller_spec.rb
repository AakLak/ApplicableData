require 'rails_helper'

RSpec.describe NavController, type: :controller do
  describe "GET nav_features" do
  it "Returns a 200 OK status" do
    get :features
    expect(response).to have_http_status(:ok)
  end
end

end
