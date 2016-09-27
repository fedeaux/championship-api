class Api::ChampionshipPerformancesController < ApplicationController
  before_action :set_championship

  def index
    @participations = @championship.participations
  end

  def create
    participation = @championship.participations.find_by(competitor_id: performance_params[:competitor_id])

    if participation
      @performance = @championship.class.performance_record_class.create(
        participation: participation,

        #   For now, since all performance values are numbers, we can make this.
        # a more elaborated scheme should be necessary if more competitions are added
        performance: performance_params[:performance].to_h.map{ |key, value| [key.to_sym, value.to_f] }.to_h
      )
    else
      head(422)
    end
  end

  private
  def set_championship
    @championship = Championship.find(params[:championship_id])
  end

  def performance_params
    params.require(:performance).permit(:competitor_id, performance: [ :distance, :time ])
  end
end
