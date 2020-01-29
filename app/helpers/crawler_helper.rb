require 'open-uri'
require 'json'
require 'nokogiri'

module CrawlerHelper
  class Crawler
    def initialize(url)
      @url = url
      @uri = URI.parse(url)
    end

    def varrer!
      html = response_html(@url)
      paginas = html.css(%{a}).map{ |node| node["href"] }.compact.map{|l| parse_url(l) }.compact.map(&:to_s).uniq.sort
      response = paginas.map do |pagina_url|
        parse_pagina(pagina_url)
      end
    end

    def response_html(html)
      Nokogiri::HTML(open(html))
    end

    def parse_url(url)
      uri = @uri.merge(url)
      return nil if uri.host != @uri.host
      uri
    rescue URI::InvalidURIError
      return nil
    end

    def parse_pagina(pagina_url)
      html = response_html(pagina_url)
      {
        pagina: pagina_url,
        links:  html.css(%{a}).map{|node| node["href"]}.compact.map{|l|parse_url(l)}.compact.map(&:to_s).uniq.sort,
        css:    html.css(%{link[type="text/css"]}).map{|node| node["href"]}.compact,
        js:     html.css(%{script}).map{|node| node["src"] }.compact,
        images: html.css(%{img}).map{|node| node["src"] }.compact
      }
    end

  end
end
