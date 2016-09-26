class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate!

  def authenticate!
    authenticate_user! unless params['controller'] == 'devise_token_auth/sessions'
  end
end
