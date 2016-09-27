class ChampionshipParticipation < ApplicationRecord
  belongs_to :competitor, class_name: :Athlete
  belongs_to :championship
  has_many :performances, class_name: :ChampionshipParticipationPerformance, foreign_key: :participation_id

  validates :competitor, presence: true
  validates :championship, presence: true
end
