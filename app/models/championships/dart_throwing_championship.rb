class DartThrowingChampionship < Championship
  def self.performance_record_class
    DartThrowingPerformance
  end

  def maximum_performances_per_competitor
    3
  end

  def performance_sorter(performance_a, performance_b)
    # Every child of championship must implement this method as a way of ordering performances
    # from the best to the worse
    performance_b.performance[:distance] <=> performance_a.performance[:distance]
  end
end
