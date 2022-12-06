require 'rails_helper'

RSpec.describe WeatherService do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  describe '#fetch_forecast_by_zip' do
    let(:zip_code) { "a random zip" }
    let(:response_body) { { "some": "parsable object" }.to_json }
    let(:weather_service_response) { WeatherService.new(zip_code).fetch_forecast_by_zip }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)

      stub_request(:get, /api.openweathermap.org/).to_return(status: 200, body: response_body)
      weather_service_response
    end


    it 'should cache the result' do
      expect(Rails.cache.exist?("weather_forecast/#{zip_code}")).to be true
    end

    it 'should return a response object' do
      expect(weather_service_response[:body]).to eq JSON.parse(response_body)
      expect(weather_service_response[:success]).to be true
    end
  end
end
