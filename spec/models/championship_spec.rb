require 'rails_helper'

RSpec.describe Championship, type: :model do
  describe 'factories' do
    it 'has a valid factory for one hundred metre dash' do
      championship = create :one_hundred_metre_dash
      expect(championship).to be_valid
      expect(championship.type).to eq 'OneHundredMetreDashChampionship'
    end

    it 'has a valid factory for dart throwing' do
      championship = create :dart_throwing
      expect(championship).to be_valid
      expect(championship.type).to eq 'DartThrowingChampionship'
    end

    it 'can add the trait :with_competitors' do
      championship = create :dart_throwing, :with_competitors
      expect(championship).to be_valid
      expect(championship.competitors).not_to be_empty
    end
  end

  describe 'validations' do
    it 'is invalid if not given a name' do
      championship = Championship.new name: '', type: 'DartThrowingChampionship'
      expect(championship).to be_invalid
    end

    it 'is invalid if not given a type' do
      championship = Championship.new name: 'Chess', type: ''
      expect(championship).to be_invalid
    end

    it 'raises an error if given an unimplemented championship type' do
      expect {
        championship = Championship.new name: 'UFC 102', type: 'MMAChampionship'
      }.to raise_error ActiveRecord::SubclassNotFound
    end
  end

  describe 'championship participation' do
    let(:championship) { create :one_hundred_metre_dash, :with_competitors }

    it 'has many participations' do
      expect(championship.participations.count).to be_a Numeric
    end

    it 'has many participations' do
      expect(championship.competitors.count).to be_a Numeric
    end
  end

  describe '#update' do
    let(:championship) { create :one_hundred_metre_dash }

    it 'ignores updates on type' do
      original_type = championship.type
      championship.update type: attributes_for(:dart_throwing)[:type]
      expect(championship.type).to eq original_type
    end

    it 'does not allow competitors to be removed, only added, without repetitions' do
      competitors = [ create(:athlete_demian), create(:athlete_rodolfo) ]
      new_competitor = create(:athlete_marcelo)

      championship.update competitors: competitors
      expect(championship.competitors.count).to eq 2

      championship.update competitors: [new_competitor]
      expect(championship.competitors.count).to eq 3

      championship.update competitors: competitors
      expect(championship.competitors.count).to eq 3
    end
  end

  describe '#result' do
    let(:one_hundred_metre_dash_without_performances) { create :one_hundred_metre_dash, :with_competitors }
    let(:one_hundred_metre_dash) { create :one_hundred_metre_dash, :with_competitors, :with_performances }
    let(:dart_throwing) { create :dart_throwing, :with_competitors, :with_performances }

    context 'open championship' do
      it 'returns a hash containing "Not enough data yet" if there are no performances' do
        expect(one_hundred_metre_dash_without_performances.result[:current_winner]).to eq 'Not enough data yet'
      end

      it 'returns the performance with the smallest time for OneHundredMeterDashCompetition, wrapped in "current_winner"' do
        expect(one_hundred_metre_dash.result[:current_winner][:performance][:time]).to eq 3
        expect(one_hundred_metre_dash.result[:current_winner][:competitor][:name]).to eq 'Demian Maia'
      end

      it 'returns the performance with the greatest distance for DartThrowingCompetition, wrapped in "current_winner"' do
        expect(dart_throwing.result[:current_winner][:performance][:distance]).to eq 8
        expect(dart_throwing.result[:current_winner][:competitor][:name]).to eq 'Rodolfo Vieira'
      end
    end

    context 'closed championship' do
      it 'returns the performance with the smallest time for OneHundredMeterDashCompetition, wrapped in "final_winner"' do
        one_hundred_metre_dash.update open: false
        expect(one_hundred_metre_dash.result[:final_winner][:performance][:time]).to eq 3
        expect(one_hundred_metre_dash.result[:final_winner][:competitor][:name]).to eq 'Demian Maia'
      end

      it 'returns the performance with the greatest distance for DartThrowingCompetition, wrapped in "final_winner"' do
        dart_throwing.update open: false
        expect(dart_throwing.result[:final_winner][:performance][:distance]).to eq 8
        expect(dart_throwing.result[:final_winner][:competitor][:name]).to eq 'Rodolfo Vieira'
      end
    end
  end
end
