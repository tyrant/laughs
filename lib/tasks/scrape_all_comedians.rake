
desc "Iterate over every comedian, call their scrape_(name) method, grab its gigs, and create. And clear the cache."
task scrape_all_comedians: :environment do 

  Comedian.find_each do |comedian|
    begin
      gigs = Comedian.send("scrape_#{comedian.name.parameterize.underscore}")
      comedian.create_gigs(gigs)
    rescue Exception => e
      Rails.logger.error("Oh no! Error scraping #{comedian.name}:\n")
      Rails.logger.error(e.message)
    end
  end
  
  Rails.cache.clear
end