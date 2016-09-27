collection @participations, root: :performances_by_competitor, object_root: false

child :competitor => :competitor do
  attributes :id, :name
end

node :performances do |participation|
  participation.performances.map(&:performance)
end
