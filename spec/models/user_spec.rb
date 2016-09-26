require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factories' do
    it 'has valid factories' do
      expect(build :user_ray).to be_valid
      expect(build :user_steve).to be_valid
    end

    it 'can fetch previously created users' do
      ray = create :user_ray
      ray2 = create_or_find_user :user_ray

      expect(ray.id).to eq ray2.id
    end
  end
end
