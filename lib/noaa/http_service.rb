module NOAA
  class HttpService #:nodoc:
    def initialize(http = Net::HTTP)
      @HTTP = http
    end

    def get_current_conditions(station_id)
      Nokogiri::XML(@HTTP.get(URI.parse("http://www.weather.gov/xml/current_obs/#{station_id}.xml")))
    end

    def get_forecast(num_days, lat, lng)
      Nokogiri::XML(@HTTP.get(URI.parse("http://forecast.weather.gov/MapClick.php?lat=#{lat}&lon=#{lng}&FcstType=dwml&numDays=#{num_days}")))
    end

    def get_station_list
      Nokogiri::XML(@HTTP.get(URI.parse("http://www.weather.gov/xml/current_obs/index.xml")))
    end
  end
end
