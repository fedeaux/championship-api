class ChampionshipParticipation < ApplicationRecord
  belongs_to :competitor, class_name: :Athlete
  belongs_to :championship

  validates :competitor, presence: true
  validates :championship, presence: true
end
