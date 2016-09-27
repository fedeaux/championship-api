module FactoryGirl
  module Syntax
    module Methods
      def create_or_find_user(user_factory)
        User.find_by(email: attributes_for(user_factory)[:email]) || create(user_factory)
      end

      def create_or_find_athlete(athlete_factory)
        Athlete.find_by(name: attributes_for(athlete_factory)[:name]) || create(athlete_factory)
      end

      def create_or_find_championship(championship_factory)
        Championship.find_by(name: attributes_for(championship_factory)[:name]) || create(championship_factory)
      end
    end
  end
end
