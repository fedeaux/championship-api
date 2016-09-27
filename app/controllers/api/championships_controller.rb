class Api::ChampionshipsController < ApplicationController
  before_action :set_championship, only: [:show, :update]

  def index
    @championships = Championship.all
  end

  def create
    @championship = Championship.create championship_params
    render :show_with_errors
  end

  def update
    @championship.update championship_params
    render :show_with_errors
  end

  def show
  end

  private
  def set_championship
    @championship = Championship.find(params[:id])
  end

  def championship_params
    params.require(:championship).permit(:name, :type, competitor_ids: [])
  end
end
