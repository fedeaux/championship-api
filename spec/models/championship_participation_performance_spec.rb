require 'rails_helper'

RSpec.describe ChampionshipParticipationPerformance, type: :model do
  describe 'validations' do
    let(:participation_attributes) {
      {
        type: 'DartThrowingPerformance',
        participation: create(:rodolfo_participating_on_dart_throwing),
        performance: { distance: 2.3 }
      }
    }

    it 'is invalid without a championship participation' do
      expect(ChampionshipParticipationPerformance.new participation_attributes.except(:participation)).to be_invalid
    end

    it 'is invalid without performance info' do
      expect(ChampionshipParticipationPerformance.new participation_attributes.except(:performance)).to be_invalid
    end

    it 'infer its type based on Championship type' do
      expect(ChampionshipParticipationPerformance.new(participation_attributes.except(:type)).type).
        to eq participation_attributes[:type]
    end

    it 'is invalid without a mismatch between championship type and performance type' do
      expect(ChampionshipParticipationPerformance.new participation_attributes.
        merge( type: 'OneHundredMetreDashPerformance' )).to be_invalid
    end

    it 'is invalid if the perfomance hash does not match a specific format' do
      # DartThrowingPerformance allows only { distance: Numeric }

      expect(ChampionshipParticipationPerformance.new(participation_attributes.merge( performance: { runned: 'a lot' } ))).
        to be_invalid

      expect(ChampionshipParticipationPerformance.new(participation_attributes.merge( performance: { time: 1.2 } ))).
        to be_invalid

      expect(ChampionshipParticipationPerformance.new(participation_attributes.merge( performance: {
        distance: 1.2, unknown_key: 'value' } ))).
        to be_invalid
    end

    it 'is invalid if the underlying championship has already been closed' do
      participation = create(:rodolfo_participating_on_dart_throwing, championship: create(:dart_throwing, :closed) )

      expect(ChampionshipParticipationPerformance.new(participation_attributes.merge( participation: participation ))).
        to be_invalid
    end

    it 'is invalid if the underlying championship has already reached the maximum number of performances for the given athlete' do
      max_performances = participation_attributes[:participation].championship.maximum_performances_per_competitor

      max_performances.times do
        ChampionshipParticipationPerformance.create participation_attributes
      end

      expect(ChampionshipParticipationPerformance.count).to eq max_performances
      expect(ChampionshipParticipationPerformance.create participation_attributes).to be_invalid
      expect(ChampionshipParticipationPerformance.count).to eq max_performances
    end
  end
end
