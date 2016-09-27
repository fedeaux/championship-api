module AuthHelpers
  def set_request_headers_for(user_factory)
    user = create_or_find_user user_factory
    @request_headers = user.create_new_auth_token
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
