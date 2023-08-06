class Source 
  attr_reader :feeds

  def initialize(uri)
    @uri = uri
    @feeds = []
    fetch
  end

  def fetch
    @response = HTTP.follow.get(@uri)
    detect_feeds
  end

  def detect_feeds
    if @response.headers['Content-Type'].include?('text/html')
      search_html_head
    else
      @feeds << feed(Feedjira.parse(@response.body.to_s))
    end
  end

  def search_html_head
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

  private def feed(f)
    Feed.new(url: f.url, title: f.title, etag: @response.headers['etag'], ttl: Integer(f.ttl, exception: false))
  end
end