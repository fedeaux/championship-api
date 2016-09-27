class Championship < ApplicationRecord
  validates :name, presence: true
  validates :type, presence: true

  has_many :participations, class_name: :ChampionshipParticipation
  has_many :competitors, through: :participations

  before_update :ensure_type_in_not_changed

  def closed?
    !open?
  end

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

  def self.performance_record_class
    nil
  end

  def maximum_performances_per_competitor
    1
  end

  def result
    sorter = method(:performance_sorter)

    best_performance = participations.map { |participation|
      if participation.performances.any?
        participation.performances.sort(&sorter).first
      else
        nil
      end

    }.reject(&:nil?).sort(&sorter).first

    if best_performance
      best_result = {
        performance: best_performance.performance,
        competitor: best_performance.competitor.attributes.symbolize_keys.slice(:id, :name)
      }
    else
      best_result = 'Not enough data yet'
    end

    if open?
      { current_winner: best_result }
    else
      { final_winner: best_result }
    end
  end
end
