class ChampionshipParticipationPerformance < ApplicationRecord
  belongs_to :participation, class_name: :ChampionshipParticipation
  has_one :championship, through: :participation
  has_one :competitor, through: :participation

  validates :type, presence: true
  validates :participation, presence: true
  validates :performance, presence: true

  validate :type_matches_championship_type
  validate :valid_performance_format
  validate :championship_must_be_open
  validate :cannot_exceed_championships_maximum_performances_per_competitor

  serialize :performance

  after_initialize :ensure_type

  def ensure_type
    if type.nil? and participation
      self.type = participation.championship.class.performance_record_class
    end
  end

  def valid_performance_format
    if performance.is_a? Hash
      expected_format = performance_format

      unknown_keys = performance.keys - expected_format.keys
      missing_keys = expected_format.keys - performance.keys

      if unknown_keys.any?
        errors.add(:performance, "Unknown keys for #{type}: #{unknown_keys.inspect}")
      end

      if missing_keys.any?
        errors.add(:performance, "Missing keys for #{type}: #{missing_keys.inspect}")
      end

      expected_format.each do |name, field_type|
        unless performance[name].is_a? field_type
          errors.add(:performance, "Wrong type for performance[:#{type}]: expected #{field_type}, given: #{performance[name].class.name}")
        end
      end

    else
      errors.add(:performance, 'Wrong format, Hash expected')
    end
  end

  def type_matches_championship_type
    if participation
      expected_class = participation.championship.class.performance_record_class

      if type != expected_class.to_s
        errors.add(:type, "Cannot add a #{type} to a #{participation.championship.class}, expected #{expected_class}")
      end
    end
  end

  def championship_must_be_open
    if participation
      if participation.championship.closed?
        errors.add(:participation, "Cannot add a performance to a closed championship")
      end
    end
  end

  def performance_format
    type.constantize.performance_format if type
  end

  def cannot_exceed_championships_maximum_performances_per_competitor
    if participation and participation.performances.count == participation.championship.maximum_performances_per_competitor
      errors.add(:participation, "Maximum number of performances reached for this athlete on this championship")
    end
  end
end
