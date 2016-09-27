FactoryGirl.define do
  factory :championship_participation do
    competitor { create :athlete_demian }
    championship { create :one_hundred_metre_dash }
  end

  factory :rodolfo_participating_on_one_hundred_metre_dash, class: :championship_participation do
    competitor { create_or_find_athlete :athlete_rodolfo }
    championship { create_or_find_championship :one_hundred_metre_dash }
  end

  factory :demian_participating_on_one_hundred_metre_dash, class: :championship_participation do
    competitor { create_or_find_athlete :athlete_demian }
    championship { create_or_find_championship :one_hundred_metre_dash }
  end

  factory :marcelo_participating_on_one_hundred_metre_dash, class: :championship_participation do
    competitor { create_or_find_athlete :athlete_marcelo }
    championship { create_or_find_championship :one_hundred_metre_dash }
  end

  factory :rodolfo_participating_on_dart_throwing, class: :championship_participation do
    competitor { create_or_find_athlete :athlete_rodolfo }
    championship { create_or_find_championship :dart_throwing }
  end

  factory :demian_participating_on_dart_throwing, class: :championship_participation do
    competitor { create_or_find_athlete :athlete_demian }
    championship { create_or_find_championship :dart_throwing }
  end

  factory :marcelo_participating_on_dart_throwing, class: :championship_participation do
    competitor { create_or_find_athlete :athlete_marcelo }
    championship { create_or_find_championship :dart_throwing }
  end
end
