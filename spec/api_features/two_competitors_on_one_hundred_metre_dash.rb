require 'rails_helper'

describe "Two competitiors on one hundred metre dash championship", type: :request do
  it 'allows athlete and championship creation, fetching partial results, closing the championship and fetching final results' do

    # User management not implemented
    set_request_headers_for :user_ray

    # Create a championship
    post api_championships_path, headers: @request_headers, params: {
      championship: {
        name: '100 metros rasos',
        type: 'OneHundredMetreDashChampionship'
      }
    }

    championship_id = JSON.parse(response.body)['championship']['id']

    # Create the athletes
    post api_athletes_path, headers: @request_headers, params: {
      athlete: {
        name: "Mariana Silva"
      }
    }

    mariana_id = JSON.parse(response.body)['athlete']['id']

    post api_athletes_path, headers: @request_headers, params: {
      athlete: {
        name: "Juliana Souza"
      }
    }

    juliana_id = JSON.parse(response.body)['athlete']['id']

    # Assign the athletes to the championship
    put api_championship_path(championship_id), headers: @request_headers, params: {
      championship: {
        competitor_ids: [juliana_id, mariana_id]
      }
    }

    # Get championship info, showing that there is not enough data yet
    get api_championship_path(championship_id), headers: @request_headers
    expect(JSON.parse(response.body)['championship']['result']['current_winner']).to eq "Not enough data yet"

    # Create a performance record for Juliana
    post api_championship_performances_path(championship_id: championship_id), headers: @request_headers, params: {
      performance: {
        performance: {
          time: 12.3
        },
        competitor_id: juliana_id
      }
    }

    # Get championship info, showing that juliana is the current winner
    get api_championship_path(championship_id), headers: @request_headers
    expect(JSON.parse(response.body)['championship']['result']['current_winner']['competitor']['name']).to eq "Juliana Souza"
    expect(JSON.parse(response.body)['championship']['result']['current_winner']['performance']['time']).to eq 12.3

    # Create a performance record for Mariana
    post api_championship_performances_path(championship_id: championship_id), headers: @request_headers, params: {
      performance: {
        performance: {
          time: 11.2
        },
        competitor_id: mariana_id
      }
    }

    # Close the championship
    put api_championship_path(championship_id), headers: @request_headers, params: {
      championship: {
        open: false
      }
    }

    # Get the final winner, Mariana Silva with 11.2s
    get api_championship_path(championship_id), headers: @request_headers
    expect(JSON.parse(response.body)['championship']['result']['final_winner']['competitor']['name']).to eq "Mariana Silva"
    expect(JSON.parse(response.body)['championship']['result']['final_winner']['performance']['time']).to eq 11.2

    # Trying to add a performance now will not work
    post api_championship_performances_path(championship_id: championship_id), headers: @request_headers, params: {
      performance: {
        performance: {
          time: 9.7
        },
        competitor_id: juliana_id
      }
    }

    # Mariana Silva still the winner
    get api_championship_path(championship_id), headers: @request_headers
    expect(JSON.parse(response.body)['championship']['result']['final_winner']['competitor']['name']).to eq "Mariana Silva"
    expect(JSON.parse(response.body)['championship']['result']['final_winner']['performance']['time']).to eq 11.2
  end
end
