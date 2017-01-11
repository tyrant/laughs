class Comedian < ApplicationRecord

  # Each comedian has many gigs; each gig has many comedians. 
  # This allows for multiple comedians on the same bill, you see.
  has_and_belongs_to_many :gigs


  # Hit up jimmycarr.co.uk/live and iterate over each of the upcoming gigs listed there.
  # For each gig, we grab its name and see if we've already got it listed in our own database.
  # If that gig doesn't exist, we grab the following bits of info: 
  # (1) The gig's date (dd/mm/yyyy)
  # (2) The name of the venue it's at
  # (3) The venue's booking URL
  # (4) If it exists, the Ticketmaster booking URL
  # Next, we see if our new gig's venue exists or not in our database too.
  # If not, we hit up Google's Geocoding API to get the latitude, longitude and address string from the venue name.
  # Then we save the venue to our database.
  # Finally, save the gig.
  def Comedian.scrape_jimmy_carr

    # Use open() to get the HTML text for Jimmy Carr's Upcoming Gigs page,
    # then use Nokogiri to construct its DOM for our parsing pleasure.
    html_text = open('http://www.jimmycarr.com/live/')
    dom = Nokogiri::HTML(html_text)

    # Grab each individual gig on Jimmy Carr's gig page, and iterate over it.
    dom.css('.accordion-group').each do |html_gig|

      # Grab our candidate-gig's date value, and its venue name:

      # The date string, in dd/mm/yyyy format.
      gig_date_s = html_gig.at_css('.gig-date').text 

      # Build a Time object from it.
      gig_date = Time.new(gig_date_s[6,4], gig_date_s[3,2], gig_date_s[0,2])

      # Grab the venue's name/city string, and extract each.
      city_venue = html_gig.at_css('.gig-city-venue').text
      venue_name = city_venue.split('-')[1].strip
      venue_city = city_venue.split('-')[0].strip

      # Does this gig already exist in our database? Let's find out.
      unless Gig.joins(:venue).where('venues.name = ? AND gigs.time = ?', venue_name, gig_date).first

        # Apparently not! Let's create it. Next - does this gig's venue not exist
        # and need creating too?
        unless venue = Venue.find_by_name(venue_name) 

          # Don't look like it. Let's create it then.

          # We build an address string. The geocoder gem takes this, hits up the Google geocoder
          # API, that squirts back a latitude and longitude, and attaches those to the Venue
          # object.
          readable_address = "#{venue_name}, #{venue_city}, United Kingdom"

          # create() builds the Venue object, then immediately saves it to the database.
          venue = Venue.create({
            name:             venue_name,
            readable_address: readable_address # Temporary! Venue#get_place extracts a more comprehensive one.
          })
        end

        # Great. The 'venue' variable now holds either an existing or created Venue object.
        # Use that to attach to the Gig object we're creating.

        # Now that we're sure we're creating a new Gig, grab the booking and/or Ticketmaster URLs.
        # What's this Xpath syntax? Check out http://stackoverflow.com/questions/3655549.
        ticket_html = html_gig.at_css('.gig-purchase-tickets')
        venue_url = ticket_html.at_xpath('//*[text()[contains(., "VENUE")]]')['href']
        ticketmaster_url = ticket_html.at_xpath('//*[text()[contains(., "TICKETMASTER")]]')['href']

        # Fire that sucker up.
        Gig.create({
          comedians:                [Comedian.find_by_name('Jimmy Carr')],
          venue:                    venue,
          time:                     gig_date,
          venue_booking_url:        venue_url,
          ticketmaster_booking_url: ticketmaster_url
        })

      end
    end

    # And we're done!
  end


  def Comedian.scrape_eddie_izzard

    dom = Nokogiri::HTML(open('http://www.eddieizzard.com/shows'))

    dom.css('.gig').each do |html_gig|

      gig_date_s = html_gig.at_css('.details h5').text.split('-')[1].strip # Something like 'Tue 10 January'
      gig_time_s = html_gig.at_css('.summary .note').text.strip
      gig_date = DateTime.parse("#{gig_date_s} #{gig_time_s}")

      venue_name = html_gig.css('.details dd')[0].text.strip
      venue_city = html_gig.css('.details dd')[1].text.strip

      unless Gig.joins(:venue).where('venues.name = ? AND gigs.time = ?', venue_name, gig_date).first

        unless venue = Venue.find_by_name(venue_name)
          venue = Venue.create({
            name:             venue_name,        
            readable_address: "#{venue_name} #{venue_city}"
          })
        end

        Gig.create({
          comedians:         [Comedian.find_by_name('Eddie Izzard')],
          venue:             venue,
          time:              gig_date,
          venue_booking_url: html_gig.at_css('.details a[rel="external"]')['href'].strip
        })
      end
    end
  end


  def Comedian.scrape_dara_o_briain

    dom = Nokogiri::HTML(open('http://www.daraobriain.com/dates/'))

    dom.css('table[width="420"] tr').each do |html_gig|

    end
  end
end