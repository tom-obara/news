require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
require "date"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }

# enter your Dark Sky API key here
ForecastIO.api_key = "dd7119cf457fab4820976f1f6439bf46"
news = HTTParty.get("http://newsapi.org/v2/top-headlines?country=us&apiKey=4c129b573c4c4457b98ef4088b5bf1fe").parsed_response.to_hash

get "/" do
  view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates
    @forecast = ForecastIO.forecast(lat_long[0],lat_long[1]).to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @current_summary = @forecast["currently"]["summary"]
    @forecast_temperature = Array.new
    @forecast_summary = Array.new
        y = 0
    for day in @forecast["daily"]["data"] do
    @forecast_temperature[y] = day["temperatureHigh"]
    @forecast_summary[y] = day["summary"]
        y = y+1
    end

    @headline=Array.new
    @link=Array.new
    x = 0
    for story in news["articles"] do
    @headline[x]=story["title"]
    @link[x]=story["url"]
        x = x+1
    end
    
    view "news"
end