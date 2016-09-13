require 'rails_helper'

RSpec.describe SalesController, type: :controller do
  describe "GET index" do
    it "Requires login" do
      get :index
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET rfm_score" do
    it "Requires login" do
      get :rfm_score
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET lifecycle_grid" do
    it "Requires login" do
      get :lifecycle_grid
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET create" do
    it "Requires login" do
      get :create
      expect(flash[:alert]).to be_present
    end
  end
end
