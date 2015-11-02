require 'rails_helper'

RSpec.describe DemosController, type: :controller do

  describe "GET #first" do
    it "returns http success" do
      get :first
      expect(response).to have_http_status(:success)
    end
  end

end
