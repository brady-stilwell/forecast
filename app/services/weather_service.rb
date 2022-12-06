
class WeatherService

  include HTTParty

  base_uri "https://api.openweathermap.org"

  attr_reader :zip_code

  def initialize(zip_code)
    @zip_code = zip_code
    @options = { query: { q: "#{zip_code},us", appid: ENV["OPEN_WEATHER_TOKEN"], units: "imperial" }, format: :json }
  end

  def fetch_forecast_by_zip
    Rails.cache.fetch("weather_forecast/#{zip_code}", expires_in: 30.minutes) do
      response = self.class.get("/data/2.5/weather", @options)
      construct_response(response)
    end
  end

  private

  def construct_response(response)
    { success: response.success?, body: response.parsed_response }
  end
end
