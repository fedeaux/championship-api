class Api::ChampionshipsController < ApplicationController
  def index
    @championships = Championship.all
  end

  def create
    @championship = Championship.create championship_params
  end

  def show
    @championship = Championship.find_by(id: params[:id])
    head 404 unless @championship
  end

  private
  def championship_params
    params.require(:championship).permit(:name, :type)
  end
end
