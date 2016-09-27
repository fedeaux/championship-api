class DartThrowingChampionship < Championship
  def self.performance_record_class
    DartThrowingPerformance
  end

  def maximum_performances_per_competitor
    3
  end
end
