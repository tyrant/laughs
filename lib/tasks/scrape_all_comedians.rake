
desc "Iterate over every comedian, call their scrape_(name) method, grab its gigs, and create."
task scrape_all_comedians: :environment do 

  Comedian.find_each do |comedian|
    gigs = Comedian.send("scrape_#{comedian.name.parameterize.underscore}")
    comedian.create_gigs(gigs)
  end
  Rails.cache.clear
end