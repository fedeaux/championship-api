object @athlete => :athlete
extends 'api/athletes/base'

node :errors do |athlete|
  athlete.errors.messages
end
