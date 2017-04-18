class AlertsController < ApplicationController

  before_action :authenticate_user!


  def index
    render json: Alert.where(user: current_user)
  end


  def create
    alert = Alert.create(strong_params.merge!(user: current_user))
    render json: alert
  end


  def destroy
    alert = Alert.find(strong_params[:id])
    alert.destroy
    render json: alert
  end


  private

  def strong_params
    params.permit(:id, :google_place_id, :city_country, :readable_address)
  end

end