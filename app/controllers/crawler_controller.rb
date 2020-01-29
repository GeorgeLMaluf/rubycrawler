class CrawlerController < ApplicationController
  def index
    target_url = params[:url]
    crawler = CrawlerHelper::Crawler.new(params[:url])
    results = JSON.pretty_generate(crawler.varrer!)

    @results = CrawlerResults.new
    @results.url = target_url
    @results.conteudo = results
  end

  def create
    redirect_to action: "index", url: params[:url] 
  end
end
