require 'rails_helper'

RSpec.describe "WelcomePages", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/welcomes"
      expect(response).to have_http_status(:success)
    end
  end

end
