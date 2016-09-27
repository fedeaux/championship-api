object @performance => :performance
attributes :id, :performance

node :errors do |performance|
  performance.errors.messages
end
