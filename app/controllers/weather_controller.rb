class WeatherController < ApplicationController
  before_action :set_client, only: :fetch_forecast
  before_action :set_response_cached?, only: :fetch_forecast

  def new; end

  def fetch_forecast
    response = @client.fetch_forecast_by_zip
    render json: { success: response[:success], data: response[:body], cached: @response_cached }
  end

  private

  def set_response_cached?
    # before we call the service above lets see if it exists in the cache
    @response_cached = Rails.cache.exist?("weather_forecast/#{params[:zip]}")
  end

  def set_client
    @client = WeatherService.new(zip_code: params[:zip])
  end
end
