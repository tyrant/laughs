class Comedian < ApplicationRecord

  # Each comedian has many gigs; each gig has many comedians. 
  # This allows for multiple comedians on the same bill, you see.
  has_and_belongs_to_many :gigs
  has_many :venues, through: :gigs

  has_attached_file :mugshot, styles: { thumb: "100x100#" }
  validates_attachment_content_type :mugshot, content_type: /\Aimage\/.*\z/

  # Every comedian has their own website, with its own structure and quirks, so
  # we need to have a separate method for each one.
  # Quick note on the structure of each scraping method. You can process the lot
  # by doing something like, as per our Rake task:
  # Comedian.find_each do |comedian| 
  #   gigs = Comedian.send("scrape_#{c.parameterize.underscore}")
  #   comedian.create_gigs(gigs)
  # end


  # Hit up jimmycarr.co.uk/live and iterate over each of the upcoming gigs listed there.
  # For each gig, we grab its name and see if we've already got it listed in our own database.
  # If that gig doesn't exist, we grab the following bits of info: 
  # (1) The gig's date (dd/mm/yyyy)
  # (3) The venue's booking URL
  # (4) If it exists, the Ticketmaster booking URL
  # (5) A Google Places API object describing the venue.
  def Comedian.scrape_jimmy_carr

    # Use open() to get the HTML text for Jimmy Carr's Upcoming Gigs page,
    # then use Nokogiri to construct its DOM for our parsing pleasure.

    html_text = open('http://www.jimmycarr.com/live/?show=2017-uk-tour-dates')
    dom = Nokogiri::HTML(html_text)

    # Grab each individual gig on Jimmy Carr's gig page, and iterate over it.
    # Note the 'map'. This iterates over each of Jimmy Carr's gigs, and collects
    # them into an array of hashes of useful bits of stuff.
    dom.css('.accordion').map do |html_gig|

      # Grab our candidate-gig's date value, and its venue name:

      # The date string, in dd/mm/yyyy format.
      gig_date_s = html_gig.at_css('.date').text 

      # Grab the venue's name/city string, then plug that into the Google Places API later,
      # to get things like its Place ID, Google's unique identifier for every location
      # on Earth. Useful!
      venue_deets = html_gig.at_css('.city-venue').text.strip

      # Grab the booking and/or Ticketmaster URLs.
      # What's this Xpath syntax? Check out http://stackoverflow.com/questions/3655549.
      ticket_html = html_gig.at_css('.buttons-section')
      venue_url = ticket_html.at_xpath('//*[text()[contains(., "VENUE")]]')['href']
      ticketmaster_url = ticket_html.at_xpath('//*[text()[contains(., "TICKETMASTER")]]')['href']

      {
        date:                     gig_date_s,
        venue_booking_url:        venue_url,
        ticketmaster_booking_url: ticketmaster_url,
        venue_deets:              venue_deets
      }
    end

    # And we're done with our web scraping! Ruby functions automatically return whatever
    # variable was defined or mentioned last, so dom.css('.accordion').map, above, will
    # return our scraped array of website gig/venue details to whatever function called this.
  end


  # Working as of 2017-01-17
  def Comedian.scrape_eddie_izzard

    dom = Nokogiri::HTML(open('http://www.eddieizzard.com/shows'))
    dom.css('.gig').map do |html_gig|

      gig_date_s = html_gig.at_css('.details h5').text.split('-')[1].strip
      gig_time_s = html_gig.at_css('.summary .note').text.strip

      {
        date:              "#{gig_date_s} #{gig_time_s}",
        venue_booking_url: html_gig.at_css('.details a[rel="external"]')['href'].strip,
        venue_deets:       html_gig.at_css('.details dd').text.strip
      }
    end
  end


  # Working as of 2017-01-17
  def Comedian.scrape_dara_o_briain

    dom = Nokogiri::HTML(open('http://www.daraobriain.com/dates/'))

    # The first two rows of Dara's Upcoming Gigs table are headers/titles. Skip.
    # Likewise, each row with actual gig data alternates with some kind of spacer row.
    gigs = dom.css('table[width="420"] tr:nth-child(2n+3)').map do |html_gig|

      gig_date_s = html_gig.at_css('td:nth-child(1)').text.strip
      booking_td = html_gig.at_css('td:nth-child(5)')
      venue_booking_url = if booking_td.at_css('a')
        booking_td.at_css('a')['href']
      else
        ''
      end

      {
        date:              gig_date_s,
        venue_booking_url: venue_booking_url,
        venue_deets:       html_gig.at_css('td:nth-child(3)').text.strip
      }
    end
    
    # Trim off any we still couldn't get dates from.
    gigs.select!{ |g| g[:date].present? }

    gigs
  end


  # Working as of 2017-01-17
  def Comedian.scrape_ed_byrne

    dom = Nokogiri::HTML(open('http://edbyrne.com/live-dates/'))

    dom.css('.each-date').map do |html_gig|

      gig_date_s = html_gig.at_css('.date-when').text.strip
      location = html_gig.at_css('.date-location').text.strip
      venue_deets = html_gig.at_css('.date-venue').text.strip
      phone = if html_gig.at_css('.date-telephone')
        html_gig.at_css('.date-telephone').text.strip
      else 
        nil
      end

      {
        date:                     gig_date_s,
        venue_deets:              "#{location} #{venue_deets}",
        phone:                    phone,
        ticketmaster_booking_url: html_gig.at_css('.date-buy')['href'] 
      }
    end
  end



  def Comedian.scrape_micky_flanagan

    dom = Nokogiri::HTML(open('http://www.livenation.co.uk/artist/micky-flanagan-tickets'))

    dom.css('.artistticket').map do |html_gig|
      venue = html_gig.at_css('.artistticket__venue').text.strip
      city = html_gig.at_css('.artistticket__city').text.strip

      {
        date:              html_gig.at_css('.artistticket__date').text.strip,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('.artistticket__link')['href']
      }
    end
  end


  def Comedian.scrape_bill_burr

    dom = Nokogiri::HTML(open('http://billburr.com/events/'))

    dom.css('.post').map do |html_gig|

      venue = html_gig.at_css('h2').text.strip
      city = html_gig.at_css('.info').text.strip

      {
        date:              html_gig.at_css('.date').text.strip,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('a.button')['href']
      }
    end
  end


  def Comedian.scrape_jim_jefferies

    dom = Nokogiri::HTML(open('http://jimjefferies.com/events'))

    dom.css('.list-item').map do |html_gig|

      venue = html_gig.at_css('.event-info-location').text.strip
      city = html_gig.at_css('.event-info-title').text.strip

      {
        date:              html_gig.at_css('.event-date').text.strip,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('.btn-t-buy')['href']
      }
    end     
  end


  def Comedian.scrape_rhys_darby

    dom = Nokogiri::HTML(open('http://www.rhysdarby.com/gigs/'))

    dom.css('table.gigs .gig').map do |html_gig|

      city = html_gig.at_css('.city').text.strip
      venue = html_gig.at_css('.venue').text.strip
      venue_booking_url = if html_gig.at_css('.tickets a')
        html_gig.at_css('.tickets a')['href']
      else 
        ''
      end

      # Bit finicky. Rhys's gig dates are in dd/mm/yy, which unless dd>12, DateTime.parse()
      # interprets ass yy/mm/dd. Sneak '20' into yy, making it yyyy.
      d = html_gig.at_css('.date').text.strip.split('/')

      {
        date:              "#{d[0]}/#{d[1]}/20#{d[2]}",
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: venue_booking_url
      }
    end
  end


  def Comedian.scrape_ross_noble
    
    dom = Nokogiri::HTML(open('http://www.rossnoble.co.uk/tour/'))

    dom.css('.entry-content tr:nth-child(n+2)').map do |html_gig|

      city = html_gig.at_css('td:nth-child(2)').text.strip
      venue = html_gig.at_css('td:nth-child(3)').text.strip

      {
        date:              html_gig.at_css('td:nth-child(1)').text.strip,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('td:nth-child(4) a')['href']
      }
    end
  end


  def Comedian.scrape_sean_lock
    {}
  end


  # Receive a whole bunch of freshly scraped gigs. If they don't exist, create them.
  def create_gigs(gigs = {})

    gigs.each do |gig|

      # We really, really don't want to hit the Places API every single goddamn time
      # we check a venue's uniqueness. Chew up our quota in no time.
      # I know the daily limit is 150,000, but still. Let's be scalable.
      # First, use our scraped 'venue_deets' to query for the venue.

      # Slight problem. Say two or more sites have crappy, differing descriptions 
      # for the same venue. We don't want to create multiple venue objects that turn out
      # to have the same place ID. So if finding an existing venue from venue_deets
      # doesn't work, hit up the Places API, get a place ID, and query for that.
      unless venue = Venue.find_by_deets(gig[:venue_deets])

        # No luck! Hit up the Places API. If GP returns no results, or throws a
        # query limit exception, we still want the venue saved. 
        begin
          place = GP.first_plausible_spot(gig[:venue_deets])
        rescue
          place = nil
        end

        # If we get a place result, query for a venue in our database based on place ID.
        venue = Venue.find_by_google_place_id(place.id) if place.present? 

        unless venue.present?

          # No result there either, eh? Fine. Create the frickin' thing. 
          venue = Venue.create({
            name:             place.present? ? place.name : nil,        
            readable_address: place.present? ? place.formatted_address : nil,
            latitude:         place.present? ? place.lat : nil,
            longitude:        place.present? ? place.lng : nil,
            google_place_id:  place.present? ? place.place_id : nil,
            phone:            gig[:phone],
            deets:            gig[:venue_deets]
          })
        end
      end

      # Great. Now we've got our found/created venue. Next, we query for the existence
      # of our gig too.
      date = DateTime.parse(gig[:date])
      unless Gig.where(venue: venue, time: date).first

        # Doesn't exist. Make it.
        Gig.create({
          comedians:                [self],
          venue:                    venue,
          time:                     date,
          venue_booking_url:        gig[:venue_booking_url],
          ticketmaster_booking_url: gig[:ticketmaster_booking_url]
        })
      end
    end

    # And we're done!
  end

end