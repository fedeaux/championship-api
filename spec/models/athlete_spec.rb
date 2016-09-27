require 'rails_helper'

RSpec.describe Athlete, type: :model do
  describe 'factories' do
    it 'has valid factories' do
      expect(build :athlete_rodolfo).to be_valid
      expect(build :athlete_demian).to be_valid
      expect(build :athlete_marcelo).to be_valid
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      expect(Athlete.new).to be_invalid
    end
  end
end
