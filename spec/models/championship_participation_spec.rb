require 'rails_helper'

RSpec.describe ChampionshipParticipation, type: :model do
  describe 'factories' do
    it 'has valid factories' do
      expect(build :championship_participation).to be_valid

      expect(build :rodolfo_participating_on_one_hundred_metre_dash).to be_valid
      expect(build :demian_participating_on_one_hundred_metre_dash).to be_valid
      expect(build :marcelo_participating_on_one_hundred_metre_dash).to be_valid

      expect(build :rodolfo_participating_on_dart_throwing).to be_valid
      expect(build :demian_participating_on_dart_throwing).to be_valid
      expect(build :marcelo_participating_on_dart_throwing).to be_valid
    end
  end

  describe 'validations' do
    it 'is invalid without a competitor' do
      expect(build :championship_participation, competitor: nil).to be_invalid
    end

    it 'is invalid without a championship' do
      expect(build :championship_participation, championship: nil).to be_invalid
    end
  end
end
