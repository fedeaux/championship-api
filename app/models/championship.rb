class Championship < ApplicationRecord
  validates :name, presence: true
  validates :type, presence: true

  has_many :participations, class_name: :ChampionshipParticipation
  has_many :competitors, through: :participations
end
