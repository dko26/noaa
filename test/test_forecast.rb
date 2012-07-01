require File.join(File.dirname(__FILE__), 'test_helper')

class TestForecast < NOAA::TestCase
  XML_DOC = Nokogiri::XML(open(File.join(File.dirname(__FILE__), 'data', 'forecast.xml')))
  
  ### TODO - either NOAA is ignoring the day count or the param name has changed
  should 'return number of days' do
    #forecast.length.should == 4
    forecast.length.should == 7
  end

  ['2008-12-23', '2008-12-24', '2008-12-25', '2008-12-26'].each_with_index do |date, i|
    should "return correct start time for day #{i}" do
      forecast[i].starts_at.should == Time.parse("#{date} 06:00:00 -05:00")
    end
  end

  ['2008-12-24', '2008-12-25', '2008-12-26', '2008-12-27'].each_with_index do |date, i|
    should "return correct end time for day #{i}" do
      forecast[i].ends_at.should == Time.parse("#{date} 06:00:00 -05:00")
    end
  end

  [32, 49, 43, 41].each_with_index do |temp, i|
    should "return correct high for day #{i}" do
      forecast[i].high.should == temp
    end
  end

  [31, 41, 33, 39].each_with_index do |temp, i|
    should "return correct low for day #{i}" do
      forecast[i].low.should == temp
    end
  end

  ['Rain', 'Rain', 'Slight Chance Rain', 'Chance Rain'].each_with_index do |summary, i|
    should "return correct weather summary for day #{i}" do
      forecast[i].weather_summary.should == summary
    end
  end

  4.times do |i|
    should "return correct weather type code for day #{i}" do
      forecast[i].weather_type_code.should == :sct
    end
  end

  [80, 90, 20, 50].each_with_index do |probability, i|
    should "return correct image URL for day #{i}" do
      forecast[i].image_url.should == "http://www.nws.noaa.gov/weather/images/fcicons/ra#{probability}.jpg"
    end
  end

  [5, 94, 22, 50].each_with_index do |probability, i|
    should "return correct daytime probability of precipitation for day #{i}" do
      forecast[i].daytime_precipitation_probability.should == probability
    end
  end

  [77, 84, 19, 50].each_with_index do |probability, i|
    should "return correct evening probability of precipitation for day #{i}" do
      forecast[i].evening_precipitation_probability.should == probability
    end
  end

  private

  def forecast
    @forecast ||= NOAA::Forecast.from_xml(XML_DOC)
  end
end
