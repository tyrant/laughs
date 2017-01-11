class ScrapeSitesJob < ApplicationJob

  queue_as :default

  def perform
    Comedian.scrape_jimmy_carr
  end
end
