class Api::ChampionshipPerformancesController < ApplicationController
  before_action :set_championship

  def index
    @participations = @championship.participations
  end

  private
  def set_championship
    @championship = Championship.find(params[:championship_id])
  end
end
