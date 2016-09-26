class Api::AthletesController < ApplicationController
  def index
    @athletes = Athlete.all
  end

  def create
    @athlete = Athlete.create athlete_params
  end

  def show
    @athlete = Athlete.find_by(id: params[:id])
    head 404 unless @athlete
  end

  private
  def athlete_params
    params.require(:athlete).permit(:name)
  end
end
