require 'rails_helper'

RSpec.describe "Championships requests", type: :request do
  let(:dash_championship) { create :one_hundred_metre_dash, :with_competitors, :with_performances }
  let(:dart_championship) { create :dart_throwing, :with_competitors, :with_performances }

  context "Unauthorized" do
    it 'returns an unauthorized status' do
      get api_championship_performances_path(championship_id: dash_championship.id)
      expect(response).to have_http_status 401
    end
  end

  context "Authorized" do
    before :each do
      set_request_headers_for :user_ray
    end

    describe "GET api/championships/:championship_id/championship_performances" do
      it 'returns a list of performances by competitor for the given championships' do
        get api_championship_performances_path(championship_id: dart_championship.id), headers: @request_headers
        json_response = JSON.parse(response.body)

        expect(json_response).to have_key('performances_by_competitor')
        expect(json_response['performances_by_competitor'].count).to eq dart_championship.participations.count
        expect(json_response['performances_by_competitor'].first).to have_key 'competitor'
        expect(json_response['performances_by_competitor'].first).to have_key 'performances'
      end
    end
  end
end
