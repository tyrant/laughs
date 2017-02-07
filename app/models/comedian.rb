class Comedian < ApplicationRecord

  # Each comedian has many gigs; each gig has many comedians. 
  # This allows for multiple comedians on the same bill, you see.
  has_and_belongs_to_many :gigs
  has_many :venues, through: :gigs

  has_attached_file :mugshot, styles: { thumb: "100x100#" }
  validates_attachment :mugshot, presence: true
  validates_attachment_content_type :mugshot, content_type: /\Aimage\/.*\z/

  validates :name, presence: true

  # Grabs the first space's position of their reversed name (i.e. the last space of their name),
  # then the string after that space (i.e. their surname), then orders by that.
  scope :ordered_by_surname, -> { order("right(name, strpos(reverse(name), ' ')) asc") }


  def as_json(params={})
    {
      id:          self.id,
      name:        self.name,
      mugshot_url: self.mugshot.url(:thumb)
    }
  end


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

    html_text = open('https://www.jimmycarr.com/live/?show=2017-uk-tour-dates')
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

    dom = Nokogiri::HTML(open('https://www.ents24.com/uk/tour-dates/sean-lock'))

    dom.css('#event-list .event-list-item-container').map do |html_gig|

      {
        date:              html_gig.at_css('.event-date').text.strip,
        venue_deets:       html_gig.at_css('.event-location').text.strip,
        venue_booking_url: html_gig.at_css('a.event-list-item')['href']
      }
    end
  end


  def Comedian.scrape_greg_davies

    dom = Nokogiri::HTML(open('http://gregdavies.co.uk/'))

    dom.css('#live .row.text-center').map do |html_gig|

      # Google Places thinks 'Newcastle City Hall' is in Australia.
      {
        date:              html_gig.at_css('div:nth-child(1)').text.strip,
        venue_deets:       "#{html_gig.at_css('div:nth-child(2)').text.strip}, United Kingdom",
        venue_booking_url: html_gig.at_css('div:nth-child(3) a')['href']
      }
    end
  end


  def Comedian.scrape_frankie_boyle

    dom = Nokogiri::HTML(open('https://www.frankieboyle.com/'))

    dom.css('.live-date').map do |html_gig|

      venue = html_gig.at_css('.venue').text.strip
      city = html_gig.at_css('.city').text.strip

      {
        date:              html_gig.at_css('.date').text.strip,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('a')['href']
      }
    end
  end


  def Comedian.scrape_jon_richardson

    dom = Nokogiri::HTML(open('http://jonrichardsoncomedy.com/gigs/'))

    # Jon's HTML is annoying. Rather than each gig being in 
    # neat, parseable <div>s or <li>s, they're in a great big single
    # list of <h3>-<p> pairs.
    gigs_container = dom.at_css('article.entry-content')

    # Grab each <h3>...
    gigs_container.css('h3').map do |gig_heading|

      h3 = gig_heading.text.strip

      # Note! What looks like a dash inside split() is not a dash, as typed on
      # my keyboard. It's copied and pasted from the website. Different characters!
      # Typing an actual dash failed to split the heading.
      city = h3.split('–')[1].strip
      date_s = h3.split('–')[0].strip

      # ...Then grab the <p> directly below it.
      p = gig_heading.at_css('+ p')
      venue = p.children[0].text.strip
      box_office = p.children[2].text.strip

      {
        date:              date_s,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: p.at_css('a')['href'],
        phone:             box_office.split(':')[1].strip
      }
    end

  end


  # No tours right now! 
  def Comedian.scrape_jason_manford
    {}
  end


  # No tours right now!
  def Comedian.scrape_lee_mack
    {}
  end


  def Comedian.scrape_mark_watson

    dom = Nokogiri::HTML(open('http://www.markwatsonthecomedian.com/category/live-shows/'))

    dom.css('.entry').map do |html_gig|

      h3 = html_gig.at_css('h3').text.strip
      city = h3.split('>')[0].strip
      venue = html_gig.at_css('.bookingdetailsleft').text.strip

      {
        date:              "#{h3.split('>')[1].strip} 2017",
        venue_deets:       "#{city} #{venue}",
        venue_booking_url: html_gig.at_css('.bookonline')['href']
      }
    end
  end


  def Comedian.scrape_bill_bailey

    dom = Nokogiri::HTML(open('http://billbailey.co.uk/tour/'))

    # Rr, another site lacking nice clean gig containers.
    dom.xpath("//div[@class='entry']/p[.//a[contains(., 'TICKET LINK')]]").map do |html_gig|

      # And resolvable dashes. Split the <p> on a variety of dashes,
      # which when copypasted into a text editor, look almost identical.
      # Trust me, they're not.
      p_text = html_gig.text.split(/-|-|–/)

      {
        date:              p_text[1].strip,
        venue_deets:       "#{p_text[2].strip} #{p_text[0].strip}",
        venue_booking_url: html_gig.at_css('a')['href']
      }
    end
  end


  # No tours right now!
  def Comedian.scrape_sarah_millican
    {}
  end


  # Oh yay, she's using some frickin' Angular app thingy called Tockify.
  # open() doesn't cut it; we'll need to use Capybara-webkit to dynamically
  # load the page's HTML, *then* grab it.
  # Can't get the Angular JS running!
  def Comedian.scrape_sara_pascoe
    {}
  end


  def Comedian.scrape_russell_howard
    
    dom = Nokogiri::HTML(open('http://www.russell-howard.co.uk/'))

    gigs = []
    dom.css('h7').each do |month_h7|

      month_year = month_h7.text.strip

      month_h7.css('+ h6').children.each do |html_gig|
        if html_gig.name == 'text' && !html_gig.text.strip.empty?
          gig_s = html_gig.text.strip
          date_s = gig_s.split('-')[0]
          venue_s = gig_s.split('-')[1]

          venue_booking_url = if venue_booking_a = html_gig.at_css('+ a')
            venue_booking_a['href']
          else
            ''
          end

          gigs << {
            date:              "#{date_s} #{month_year}",
            venue_deets:       venue_s,
            venue_booking_url: venue_booking_url
          }

        end
      end
    end

    gigs
  end


  # No tours right now!
  def Comedian.scrape_aisha_tyler
    {}
  end


  def Comedian.scrape_reginald_d_hunter
    
    dom = Nokogiri::HTML(open('http://www.reginalddhunter.com/uk-tour-2017/'))

    dom.css('.live-date').map do |html_gig|

      {
        date:              html_gig.at_css('.date').text.strip,
        venue_deets:       "#{html_gig.at_css('.country').text} #{html_gig.at_css('.venue').text}",
        venue_booking_url: html_gig.at_css('a')['href']
      }
    end
  end


  def Comedian.scrape_steve_hughes
    
    dom = Nokogiri::HTML(open('http://www.stevehughes.net.au/tour/'))

    dom.css('.eventlist-event').map do |html_gig|
      {
        date:              html_gig.at_css('.event-date').text.strip,
        venue_deets:       html_gig.at_css('.eventlist-title-link').text.strip,
        venue_booking_url: html_gig.at_xpath('//*[text()[contains(., "Tickets Here")]]')['href'] 
      }
    end
  end


  def Comedian.scrape_henning_wehn

    dom = Nokogiri::HTML(open('http://henningwehn.de/tour/'))
    gigs = []

    dom.css('.gigs_head').each do |month|

      month_year = month.text.strip
      month.css('+ .gigs_post').each do |html_gig_list|

        # Argh. Cast our HTML to text, split it by <br>, then cast it back to HTML.
        html_gig_list.children.to_s.split('<br>').each do |html_gig_text|

          html_gig = Nokogiri::HTML(html_gig_text)

          gig_s = html_gig.text.strip.split(/-|-|–/)
          day = gig_s[0]
          city = gig_s[1]
          venue = gig_s[2]

          venue_booking_url = if url = html_gig.at_css('a')
            url['href']
          else
            nil
          end

          gigs << {
            date:              "#{day} #{month_year}",
            venue_deets:       "#{venue} #{city}",
            venue_booking_url: venue_booking_url
          }
        end
      end
    end

    gigs
  end


  def Comedian.scrape_louis_ck

    dom = Nokogiri::HTML(open('https://louisck.net/tour-dates'))

    dom.css('.tour-row').map do |html_gig|

      city = html_gig.at_css('.tour-city').text.strip
      venue = html_gig.at_css('.venue-name').text.strip

      {
        date:              html_gig.at_css('.tour-date').text.strip,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('a.tickets')['href']
      }
    end
  end


  def Comedian.scrape_peter_kay
    
    dom = Nokogiri::HTML(open('http://www.stereoboard.com/peter-kay-tickets'))

    dom.css('.listing-events').map do |html_gig|

      venue = html_gig.at_css('.artistname').text.strip
      city = html_gig.at_css('.gig_location_details').text.strip

      {
        date:              html_gig.at_css('.completedate').text.strip,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('.buytickets')['href']
      }
    end
  end


  # Oh yay. http://www.omidnoagenda.com/omiddjalilievent.html is one of those 
  # nigh-unscrapable monstrosities. Can be done and has been done, but clunky as fuck.
  def Comedian.scrape_omid_djalili

    months = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december']
    current_month = nil
    year = 2016
    
    dom = Nokogiri::HTML(open("http://www.omidnoagenda.com/omiddjalilievent.html"))

    no_blank_rows = dom.css('table.style3 tr').find_all do |tr|
      !tr.text.squish.blank?
    end

    gigs_plus_month_boundaries = no_blank_rows.map do |tr|

      day = tr.at_css('td:nth-child(1)').text.squish.downcase
      is_a_month = months.any?{ |month| month.include?(day) } && !day.empty?

      # Is 'day' no longer a day of the month, but a month name? We're on a new month.
      if is_a_month && current_month.nil?
        current_month = day
        next

      elsif is_a_month
        next_month_index = months.find_index(day) % 12
        current_month = months[next_month_index]

        if current_month == 'january'
          year += 1
        end
        next

      # RRrr! St00pid custom rows. Skip.
      elsif day.empty? || day == "aug 23—27"
        next

      else 

        city = tr.at_css('td:nth-child(2)').text.squish
        venue = tr.at_css('td:nth-child(3)').text.squish
        venue_sold_out_text = if sold_out = tr.at_css('td:nth-child(3) .style4')
          sold_out.text.squish
        else
          ''
        end
        venue = venue.gsub(venue_sold_out_text, '')

        venue_booking_url = tr.at_css('a')['href']

        phone = if tr.css('td').length == 5
          tr.at_css('td:nth-child(4)').text.squish
        else
          ''
        end

        {
          date:              "#{day} #{current_month} #{year}",
          venue_deets:       "#{venue} #{city}".gsub('SOLD OUT', ''),
          phone:             phone,
          venue_booking_url: venue_booking_url
        }
      end
    end

    gigs_plus_month_boundaries.compact!
  end


  # Not written yet 
  def Comedian.scrape_stewart_lee
    {}
  end


  def Comedian.scrape_milton_jones
    
    dom = Nokogiri::HTML(open('http://www.miltonjones.com/live'))
    month_and_year = nil

    gigs_plus_nils = dom.css('#tourdates tr').map do |tr|

      if my = tr.at_css('.subheading.orange')
        month_and_year = my.text.squish
        next
      else

        {
          date:              "#{tr.at_css('.eventdate').text.squish} #{month_and_year}",
          venue_deets:       "#{tr.at_css('.venuetitle').text.squish} #{tr.at_css('.eventtown').text.squish}",
          phone:             tr.at_css('.venuenumber').text.squish,
          venue_booking_url: tr.at_css('a') ? tr.at_css('a')['href'] : ''
        }
      end

    end

    gigs_plus_nils.compact!
  end


  def Comedian.scrape_andy_zaltzman

    dom = Nokogiri::HTML(open('http://andyzaltzman.co.uk/shows/'))

    dom.css('.gigpress-table tbody:nth-child(n+2)').map do |html_gig|

      venue = html_gig.at_css('.gigpress-venue').text.squish
      city = html_gig.at_css('.gigpress-city').text.squish
      country = html_gig.at_css('.gigpress-country').text.squish

      {
        date:              html_gig.at_css('.gigpress-date').text.squish.gsub!('/17', '/2017'),
        venue_deets:       "#{venue} #{city} #{country}",
        venue_booking_url: html_gig.at_css('.gigpress-tickets-link')['href']
      }
    end
  end


  # Unscrapeable. He doesn't even give venue names. Just city names.
  def Comedian.scrape_rob_beckett
    
    # dom = Nokogiri::HTML(open("http://www.robbeckettcomedy.com/"))

    # dom.css('#gigListing li').map do |html_gig|
    #   {
    #     date: "#{html_gig.at_css('.gigdate')} 2017",
    #     venue_deets: 
    #   }
    # end

  end


  def Comedian.scrape_russell_brand

    dom = Nokogiri::HTML(open('http://russellbrand.seetickets.com/tour/russell-brand/list/1/200'))

    dom.css('.g-blocklist-item').map do |html_gig|

      {
        date:              html_gig.at_css('.text-date').text.squish,
        venue_deets:       html_gig.at_css('.g-blocklist-sub-text').children[2].text.squish,
        venue_booking_url: "http://russellbrand.seetickets.com#{html_gig.at_css('a')['href']}"
      }
    end
  end



  # Receive a whole bunch of freshly scraped gigs. If they don't exist, create them.
  def create_gigs(gigs = {})

    created_gig_count = 0

    gigs.each do |gig|

      # First, for each of our gigs, we need a venue to host it at. Query our Venues
      # table for it, or if it doesn't exist, create it.
      venue = Venue.find_or_create_by_gig_deets(gig)

      # Great. Now we've got our found/created venue. Next, we query for the existence
      # of our gig too.
      time = DateTime.parse(gig[:date])

      unless Gig.where(venue: venue, time: time).first

        # Doesn't exist. Make it.
        Gig.create({
          comedians:                [self],
          venue:                    venue,
          time:                     time,
          venue_booking_url:        gig[:venue_booking_url],
          ticketmaster_booking_url: gig[:ticketmaster_booking_url]
        })

        created_gig_count += 1
      end
    end

    # And we're done! For kewl logging purposes, return our created gig count.
    created_gig_count
  end

end