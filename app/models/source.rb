class Source 
  attr_reader :feed
  
  def initialize(uri)
    @uri = uri
    fetch
  end

  def fetch
    @response = HTTP.follow.get(@uri)
    detect_feeds
  end

  def detect_feeds
    if @response.headers['Content-Type'].include?('text/html')
      find_rss_links
    else
      @feed = Feedjira.parse(@response.body.to_s)
    end
  end

  def find_rss_links
    document = Nokogiri::HTML5.parse(@response.body.to_s)
    alt = document
            .css("link[rel~=alternate]")
            .select { _1[:type] && _1[:href] }
            .select { %w[application/rss+xml application/atom+xml application/feed+json application/json].include? _1[:type] }
            .first

    return if alt.nil?

    @uri = @response.uri.join(alt[:href]).to_s
    fetch
  end
end