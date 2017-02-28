desc "Iterate over every comedian, call their gigs_by_(name) method, grab its gigs, and create. And clear the cache."
task scrape_all_comedians: :environment do 

  Comedian.find_each do |comedian|
    comedian.delay.scrape
  end
  
  Rails.cache.clear
end