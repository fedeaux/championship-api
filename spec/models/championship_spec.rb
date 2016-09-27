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
  end
end
