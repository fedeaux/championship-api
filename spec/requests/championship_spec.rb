require 'rails_helper'

RSpec.describe "Championships requests", type: :request do
  context "Unauthorized" do
    it 'returns an unauthorized status' do
      get api_championships_path
      expect(response).to have_http_status 401
    end
  end

  context "Authorized" do
    let(:dash_championship) { create :one_hundred_metre_dash }
    let(:dart_championship) { create :dart_throwing }

    before :each do
      set_request_headers_for :user_ray
    end

    describe "GET api/championships" do
      it 'returns a list of championships' do
        dash_championship
        dart_championship

        get api_championships_path, headers: @request_headers
        json_response = JSON.parse(response.body)

        expect(json_response['championships'].map{ |c| c['championship']['id'] }.sort).
          to eq [dash_championship.id, dart_championship.id].sort
      end
    end

    describe "GET api/championships/:id" do
      it 'returns the championship info, with a message for current_winner if there are no performances' do
        dash_championship

        get api_championship_path(dash_championship.id), headers: @request_headers
        json_response = JSON.parse(response.body)

        expect(json_response['championship']['id']).to eq dash_championship.id
        expect(json_response['championship']['type']).to eq dash_championship.class.name
        expect(json_response['championship']['result']['current_winner']).to eq 'Not enough data yet'
      end

      it 'returns the championship info, with the current_winner if there are enough performances' do
        championship = create :dart_throwing, :with_competitors, :with_performances

        get api_championship_path(championship.id), headers: @request_headers
        json_response = JSON.parse(response.body)

        expect(json_response['championship']['id']).to eq championship.id
        expect(json_response['championship']['type']).to eq championship.class.name
        expect(json_response['championship']['result']['current_winner']['competitor']['name']).to eq 'Rodolfo Vieira'
        expect(json_response['championship']['result']['current_winner']['performance']['distance']).to eq 8
      end
    end

    describe "POST api/championships" do
      let(:championship_params) { attributes_for :one_hundred_metre_dash }

      it 'creates a championship and returns its info, if the parameters are valid' do
        post api_championships_path, headers: @request_headers, params: { championship: championship_params }

        json_response = JSON.parse(response.body)

        expect(json_response['championship']['name']).to eq championship_params[:name]
        expect(json_response['championship']['errors']).to be_empty

        expect(Championship.exists? json_response['championship']['id']).to be true
      end

      it 'returns an error message if the parameters are invalid' do
        post api_championships_path, headers: @request_headers, params: { championship: championship_params.merge(name: '') }

        json_response = JSON.parse(response.body)

        expect(json_response['championship']['id']).to eq nil
        expect(json_response['championship']['errors']['name']).not_to be_empty

        expect(Championship.count).to eq 0
      end
    end

    describe "PUT api/championships" do
      let(:championship) { create :one_hundred_metre_dash }
      let(:championship_params) { { name: '100 metros rasos 2016' } }

      it 'updates the championship name' do
        put api_championship_path(championship.id), headers: @request_headers, params: { championship: championship_params }

        json_response = JSON.parse(response.body)

        expect(json_response['championship']['name']).to eq championship_params[:name]
        expect(json_response['championship']['errors']).to be_empty
      end

      it 'allows competitors to be add' do
        competitors = [ create(:athlete_demian), create(:athlete_rodolfo) ]
        competitiors_ids = competitors.map(&:id)

        put api_championship_path(championship.id), headers: @request_headers,
          params: {
            championship: { competitor_ids: competitors.map(&:id) }
          }

        json_response = JSON.parse(response.body)

        expect(json_response['championship']['errors']).to be_empty
        expect(championship.competitors).to include( *competitors)
      end
    end
  end
end
