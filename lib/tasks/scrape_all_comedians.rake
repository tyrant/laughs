
desc "Iterate over every comedian, call their scrape_(name) method, grab its gigs, and create."
task :scrape_all_comedians do 

  Comedian.find_each do |comedian|
    gigs = Comedian.send("scrape_#{comedian.parameterize.underscore}")
    comedian.create_gigs(gigs)
  end
  
end