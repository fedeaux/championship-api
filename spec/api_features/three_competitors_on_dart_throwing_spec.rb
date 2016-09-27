# -*- coding: utf-8 -*-
require 'rails_helper'

describe "Two competitiors on one hundred metre dash championship", type: :request do
  it 'allows athlete and championship creation, fetching partial results, closing the championship and fetching final results' do

    # User management not implemented
    set_request_headers_for :user_ray

    # Create a championship
    post api_championships_path, headers: @request_headers, params: {
      championship: {
        name: 'Arremeço de Dardos',
        type: 'DartThrowingChampionship'
      }
    }

    championship_id = JSON.parse(response.body)['championship']['id']

    # Create the athletes

    # Stephanie
    post api_athletes_path, headers: @request_headers, params: {
      athlete: {
        name: "Stephanie Kalvan"
      }
    }

    stephanie_id = JSON.parse(response.body)['athlete']['id']

    # Miriam
    post api_athletes_path, headers: @request_headers, params: {
      athlete: {
        name: "Miriam Mariani"
      }
    }

    miriam_id = JSON.parse(response.body)['athlete']['id']

    # Karina
    post api_athletes_path, headers: @request_headers, params: {
      athlete: {
        name: "Karina Tieme"
      }
    }

    karina_id = JSON.parse(response.body)['athlete']['id']

    # Assign the athletes to the championship
    put api_championship_path(championship_id), headers: @request_headers, params: {
      championship: {
        competitor_ids: [stephanie_id, miriam_id, karina_id]
      }
    }

    # Get championship info, showing that there is not enough data yet
    get api_championship_path(championship_id), headers: @request_headers
    expect(JSON.parse(response.body)['championship']['result']['current_winner']).to eq "Not enough data yet"

    # Create performance records for Stephanie, Miriam and Karina
    # Notice that Miriam is trying to register 4 performances. The last one will be ignored since the
    #   limit for this kind of championship is 3.

    [
      [ stephanie_id, [20, 21.8, 20.4] ],
      [ miriam_id, [18, 17.8, 20.2, 22.7] ],
      [ karina_id, [19, 21.7, 21.1] ],

    ].each do |pair|
      athlete_id = pair[0]
      distances = pair[1]

      distances.each do |distance|
        post api_championship_performances_path(championship_id: championship_id), headers: @request_headers, params: {
          performance: {
            performance: {
              distance: distance
            },
            competitor_id: athlete_id
          }
        }
      end
    end

    # Get championship info, showing that Stephanie is the current winner with a 21.8m distance
    get api_championship_path(championship_id), headers: @request_headers
    expect(JSON.parse(response.body)['championship']['result']['current_winner']['competitor']['name']).to eq "Stephanie Kalvan"
    expect(JSON.parse(response.body)['championship']['result']['current_winner']['performance']['distance']).to eq 21.8

    # Close the championship
    put api_championship_path(championship_id), headers: @request_headers, params: {
      championship: {
        open: false
      }
    }

    # Get the final winner, since nothing has changed, the final winner is the same as the previous current winner
    get api_championship_path(championship_id), headers: @request_headers
    expect(JSON.parse(response.body)['championship']['result']['final_winner']['competitor']['name']).to eq "Stephanie Kalvan"
    expect(JSON.parse(response.body)['championship']['result']['final_winner']['performance']['distance']).to eq 21.8
  end
end
