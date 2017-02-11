
desc "Iterate over every comedian, call their scrape_(name) method, grab its gigs, and create. And clear the cache."
task scrape_all_comedians: :environment do 

  Comedian.find_each do |comedian|
    begin
      ap "Scraping #{comedian.name}..."
      gigs = Comedian.send("scrape_#{comedian.name.parameterize.underscore}")
      ap "Scraped #{comedian.name}, creating objects..."
      counts = comedian.create_gigs(gigs)
      ap "Created #{counts[:venues]} venues, #{counts[:gigs]} gigs and #{counts[:spots]} spots for #{comedian.name}"

    rescue Exception => e
      ap "Oh no! Error scraping #{comedian.name}:\n"
      ap e.message
      
    end
  end
  
  Rails.cache.clear
end