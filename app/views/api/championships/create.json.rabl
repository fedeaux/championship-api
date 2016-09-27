object @championship => :championship
extends 'api/championships/base'

node :errors do |championship|
  championship.errors.messages
end
