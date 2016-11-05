require "faraday"
require "json"

module NewsAPI
  class Client
    attr_reader :source, :base_url

    def initialize(source)
      @base_url = "https://newsapi.org/v1"
      @source   = source
    end

    def top_headlines
      options = {
        source: source,
        sortBy: "top",
        apiKey: ENV["NEWS_API_KEY"]
      }
      data = JSON.load(get("articles", options))
      data["articles"]
    end

    def latest_headlines
      options = {
        source: source,
        sortBy: "latest",
        apiKey: ENV["NEWS_API_KEY"]
      }
      data = JSON.load(get("articles", options))
      data["articles"]
    end

    private

    def get(path, options = {})
      conn = Faraday.new(base_url)
      resp = conn.get(path, options)
      resp.body
    end
  end
end