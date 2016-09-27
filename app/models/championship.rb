class Championship < ApplicationRecord
  validates :name, presence: true
  validates :type, presence: true

  has_many :participations, class_name: :ChampionshipParticipation
  has_many :competitors, through: :participations

  before_update :ensure_type_in_not_changed

  def ensure_type_in_not_changed
    if type_changed?
      self.type = type_was
    end
  end

  def competitors=(competitors)
    self.competitor_ids = competitors.map(&:id)
  end

  def competitor_ids=(competitor_ids)
    super (competitor_ids + competitors.map(&:id)).uniq
  end
end
