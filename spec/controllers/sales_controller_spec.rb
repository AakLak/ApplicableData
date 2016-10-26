require 'rails_helper'

RSpec.describe SalesController, type: :controller do
  describe "GET index" do
    it "Displays 'must be logged in error'" do
      get :index
      expect(flash[:alert]).to be_present
    end

    it "Responds with sucess on login" do
      sign_in FactoryGirl.create(:user)
      get :index
      response.should be_success
    end
  end

  describe "GET rfm_score" do
    it "Shows must be logged in error" do
      get :rfm_score
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET lifecycle_grid" do
    it "Shows must be logged in error" do
      get :lifecycle_grid
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET create" do
    it "Shows must be logged in error" do
      get :create
      expect(flash[:alert]).to be_present
    end
  end
end
