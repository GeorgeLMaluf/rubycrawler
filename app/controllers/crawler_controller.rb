class CrawlerController < ApplicationController
  def index
    crawler = CrawlerHelper::Crawler.new(params[:url])
    @results = JSON.pretty_generate(crawler.varrer!)
  end

  def create
    redirect_to action: "index", url: params[:url] 
  end
end
