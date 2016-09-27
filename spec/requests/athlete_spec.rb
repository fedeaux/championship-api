require 'rails_helper'

RSpec.describe "Athletes requests", type: :request do
  context "Unauthorized" do
    it 'returns an unauthorized status' do
      get api_athletes_path
      expect(response).to have_http_status 401
    end
  end

  context "Authorized" do
    let(:athlete) { create :athlete_demian }

    before :each do
      set_request_headers_for :user_ray
    end

    describe "GET api/athletes" do
      it 'returns a list of athletes' do
        athlete

        get api_athletes_path, headers: @request_headers
        json_response = JSON.parse(response.body)
        expect(json_response['athletes'].first['athlete']['id']).to eq athlete.id
      end
    end

    describe "GET api/athletes/:id" do
      it 'returns the athlete info' do
        athlete

        get api_athlete_path(athlete.id), headers: @request_headers
        json_response = JSON.parse(response.body)
        expect(json_response['athlete']['id']).to eq athlete.id
      end
    end

    describe "POST api/athletes" do
      it 'creates an athlete and returns its info, if the parameters are valid' do
        athlete_params = attributes_for :athlete_demian

        post api_athletes_path, headers: @request_headers, params: { athlete: athlete_params }

        json_response = JSON.parse(response.body)

        expect(json_response['athlete']['name']).to eq athlete_params[:name]
        expect(json_response['athlete']['errors']).to be_empty

        expect(Athlete.exists? json_response['athlete']['id']).to be true
      end

      it 'returns an error message if the parameters are invalid' do
        post api_athletes_path, headers: @request_headers, params: { athlete: { name: '' } }

        json_response = JSON.parse(response.body)

        expect(json_response['athlete']['id']).to eq nil
        expect(json_response['athlete']['errors']['name']).not_to be_empty

        expect(Athlete.count).to eq 0
      end
    end
  end
end
