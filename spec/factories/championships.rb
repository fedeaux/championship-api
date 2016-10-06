# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :one_hundred_metre_dash, class: 'OneHundredMetreDashChampionship' do
    name '100 metros rasos'
    type 'OneHundredMetreDashChampionship'
  end

  factory :dart_throwing, class: 'DartThrowingChampionship' do
    name 'Lançamento de Dardo'
    type 'DartThrowingChampionship'
  end

  trait :with_competitors do
    competitors {[
      create_or_find_athlete(:athlete_demian),
      create_or_find_athlete(:athlete_rodolfo),
    ]}
  end

  trait :closed do
    open false
  end

  trait :with_performances do
    after :create do |championship|

      klass = championship.class.performance_record_class
      performance_key = klass == OneHundredMetreDashPerformance ? :time : :distance

      # Sort the participation by competitor name in order to always get the same winner on specs.
      # By the construction of the performance, the first athlete will always win the OneHundredMetreDashChampionship
      # and the last athlete will always win the DartThrowingChampionship

      participations_ordered_by_athlete_name = championship.participations.sort{ |participation_1, participation_2|
        participation_1.competitor.name <=> participation_2.competitor.name
      }

      participations_ordered_by_athlete_name.each_with_index do |participation, index|
        # Here, for simplicity, we use i and index as the performance indicators
        championship.maximum_performances_per_competitor.times do |i|
          klass.create({
            participation: participation,
            performance: [[performance_key, index * i + index + i + 3]].to_h
          })

          # minimum time = 0 * 0 + 0 + 0 + 3 = 3
          # maximum distance = 2 * 1 + 2 + 1 + 3 = 8
        end
      end
    end
  end
end
