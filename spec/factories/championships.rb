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

      championship.participations.each_with_index do |participation, index|
        # Here, for simplicity, we use the index value as the performance indicator
        3.times do |i|
          klass.create({
            participation: participation,
            performance: [[performance_key, index * i]].to_h
          })
        end
      end
    end
  end
end
