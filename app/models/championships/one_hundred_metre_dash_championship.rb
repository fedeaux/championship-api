class OneHundredMetreDashChampionship < Championship
  def self.performance_record_class
    OneHundredMetreDashPerformance
  end

  def performance_sorter(performance_a, performance_b)
    # Every child of championship must implement this method as a way of ordering performances
    # from the best to the worse
    performance_a.performance[:time] <=> performance_b.performance[:time]
  end
end
