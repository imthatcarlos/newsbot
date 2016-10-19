require "faraday"
require "json"

module NewsAPI
  class Client
    def initialize(source)
      @base_url = "https://newsapi.org/v1"
    end

    def top_headlines
      options = {
        source: "ign",
        sortBy: "top",
        apiKey: ENV["NEWS_API_KEY"]
      }
      JSON.load(get("articles", options))
    end

    def latest_headlines
      options = {
        source: "ign",
        sortBy: "latest",
        apiKey: ENV["NEWS_API_KEY"]
      }
      JSON.load(get("articles", options))
    end

    private

    def get(path, options = {})
      conn = Faraday.new(@base_url)
      resp = conn.get(path, options)
      resp.body
    end
  end
end