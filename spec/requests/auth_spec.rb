require 'rails_helper'

RSpec.describe "Auth", type: :request do
  let(:current_user) { create :user_ray }
  let(:right_password) { attributes_for(:user_ray)[:password] }

  let(:wrong_password) { 'anything-but-a-password' }
  let(:wrong_email) { 'no.such@email.com' }

  describe "POST /auth/sign_in" do
    it "retuns an auth token on header if the right credentials are given" do
      post user_session_path, params: { email: current_user.email, password: right_password }
      expect(response).to have_http_status 200
      expect(response.headers).to have_key "access-token"
    end

    it "returns an error and no token for the wrong password" do
      post user_session_path, params: { email: current_user.email, password: wrong_password }
      expect(response.headers).not_to have_key "access-token"
      expect(JSON.parse(response.body)).to have_key "errors"
    end

    it "returns an error and no token for the wrong email" do
      post user_session_path, params: { email: wrong_email, password: wrong_password }
      expect(response.headers).not_to have_key "access-token"
      expect(JSON.parse(response.body)).to have_key "errors"
    end
  end
end
