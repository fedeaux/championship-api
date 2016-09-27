require 'rails_helper'

RSpec.describe "Championships requests", type: :request do
  let(:dart_championship) { create :dart_throwing, :with_competitors, :with_performances }
  let(:dash_championship) { create :one_hundred_metre_dash, :with_competitors }
  let(:closed_dash_championship) { create :one_hundred_metre_dash, :with_competitors, :closed }

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

    describe "POST api/championships/:championship_id/championship_performances" do
      it 'adds a performance to a championship' do
        post api_championship_performances_path(championship_id: dart_championship.id), headers: @request_headers,
          params: { performance: { performance: { distance: 10 }, competitor_id: create_or_find_athlete(:athlete_demian).id }}

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key 'performance'
        expect(json_response['performance']['performance']['distance']).to eq 10.0
      end

      it 'prohibits adding a performance to a nonparticipating athlete' do
        post api_championship_performances_path(championship_id: dart_championship.id), headers: @request_headers,
          params: { performance: { performance: { distance: 10 }, competitor_id: create_or_find_athlete(:athlete_marcelo).id } }

        expect(response).to have_http_status 422
      end

      it 'prohibits adding a performance to a closed championship' do
        post api_championship_performances_path(championship_id: closed_dash_championship.id), headers: @request_headers,
          params: { performance: { performance: { time: 10 }, competitor_id: create_or_find_athlete(:athlete_demian).id } }

        json_response = JSON.parse(response.body)
        expect(json_response['performance']['errors']['participation'].first).
          to eq "Cannot add a performance to a closed championship"
      end
    end
  end
end
