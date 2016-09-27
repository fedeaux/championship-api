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
end
