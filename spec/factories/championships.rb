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
end
