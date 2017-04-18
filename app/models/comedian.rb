class Comedian < ApplicationRecord

  # Each comedian has many gigs; each gig has many comedians. 
  # This allows for multiple comedians on the same bill, you see.

  has_many :spots
  has_many :gigs, through: :spots
  has_many :venues, through: :gigs
  has_many :comedian_alerts
  has_many :comedians, through: :comedian_alerts

  has_attached_file :mugshot, styles: { thumb: "100x100#" }
  validates_attachment :mugshot, presence: true
  validates_attachment_content_type :mugshot, content_type: /\Aimage\/.*\z/

  validates :name, presence: true

  def as_json(params = {})
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
  #   gigs = Comedian.send("gigs_by_#{c.parameterize.underscore}")
  #   comedian.create_gigs(gigs)
  # end


  # Earlier gig sources take precedence over later ones.
  def Comedian.gigs_by_jimmy_carr
    [
      Comedian.scrape_jimmy_carr_uk,
      Comedian.scrape_jimmy_carr_international,
      Comedian.scrape_ents24("Jimmy Carr")
    ].flatten
  end


  # Hit up jimmycarr.co.uk/live and iterate over each of the upcoming gigs listed there.
  # For each gig, we grab its name and see if we've already got it listed in our own database.
  # If that gig doesn't exist, we grab the following bits of info: 
  # (1) The gig's date (dd/mm/yyyy)
  # (3) The venue's booking URL
  # (4) If it exists, the Ticketmaster booking URL
  # (5) A Google Places API object describing the venue.
  def Comedian.scrape_jimmy_carr_uk

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
      venue_deets = html_gig.at_css('.city-venue').text.squish

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


  def Comedian.scrape_jimmy_carr_international

    dom = Nokogiri::HTML(open('https://www.jimmycarr.com/live/?show=2017-international-tour-dates'))

    dom.css('.live-date').map do |gig|

      {
        date:              gig.at_css('.date').text.squish,
        venue_deets:       gig.at_css('.city-venue').text.squish,
        venue_booking_url: gig.at_css('a')['href']
      }
    end
  end


  def Comedian.gigs_by_eddie_izzard
    [
      Comedian.scrape_eddie_izzard,
      Comedian.scrape_ents24("Eddie Izzard"),
    ].flatten
  end


  # Working as of 2017-01-17
  def Comedian.scrape_eddie_izzard
    dom = Nokogiri::HTML(open('http://www.eddieizzard.com/shows'))
    dom.css('.gig').map do |html_gig|

      gig_date_s = html_gig.at_css('.details h5').text.split('-')[1].squish

      {
        date:              gig_date_s,
        venue_booking_url: html_gig.at_css('.details a[rel="external"]')['href'],
        venue_deets:       html_gig.at_css('.location').text.squish
      }
    end
  end


  def Comedian.gigs_by_dara_o_briain
    [
      Comedian.scrape_dara_o_briain,
      Comedian.scrape_off_the_kerb("Dara O Briain")
    ].flatten
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


  def Comedian.gigs_by_ed_byrne
    [
      Comedian.scrape_ed_byrne,
      Comedian.scrape_ents24("Ed Byrne")
    ].flatten
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


  def Comedian.gigs_by_micky_flanagan
    [
      Comedian.scrape_micky_flanagan,
      Comedian.scrape_ents24("Micky Flanagan")
    ].flatten
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


  def Comedian.gigs_by_bill_burr

    dom = Nokogiri::HTML(open('http://billburr.com/events/'))

    dom.css('.post').map do |html_gig|

      venue = html_gig.at_css('h2').text.squish
      city = html_gig.at_css('.info').text.squish

      {
        date:              html_gig.at_css('.date').text.squish,
        venue_deets:       "#{venue} #{city}",
        venue_booking_url: html_gig.at_css('a.button')['href']
      }
    end
  end


  def Comedian.gigs_by_jim_jefferies

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


  def Comedian.gigs_by_rhys_darby

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


  def Comedian.gigs_by_ross_noble
    [
      Comedian.scrape_ross_noble,
      Comedian.scrape_ents24("Ross Noble")
    ].flatten
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


  def Comedian.gigs_by_greg_davies
    [
      Comedian.scrape_greg_davies,
      Comedian.scrape_ents24('Greg Davies')
    ].flatten
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


  def Comedian.gigs_by_frankie_boyle
    [
      Comedian.scrape_frankie_boyle,
      Comedian.scrape_ents24("Frankie Boyle")
    ].flatten
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


  def Comedian.gigs_by_jon_richardson
    [
      Comedian.scrape_jon_richardson,
      Comedian.scrape_ents24("Jon Richardson"),
      Comedian.scrape_off_the_kerb('Jon Richardson')
    ].flatten
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
  def Comedian.gigs_by_jason_manford
    []
  end


  # No tours right now!
  def Comedian.gigs_by_lee_mack
    []
  end


  def Comedian.gigs_by_mark_watson
    [
      Comedian.scrape_mark_watson,
      Comedian.scrape_ents24("Mark Watson")
    ].flatten
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


  def Comedian.gigs_by_bill_bailey

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


  def Comedian.gigs_by_sarah_millican
    [
      Comedian.scrape_ents24("Sarah Millican")
    ].flatten
  end


  def Comedian.gigs_by_russell_howard
    [
      Comedian.scrape_ents24("Russell Howard")
    ].flatten
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
  def Comedian.gigs_by_aisha_tyler
    []
  end


  def Comedian.gigs_by_reginald_d_hunter
    [
      Comedian.scrape_reginald_delicious_hunter,
      Comedian.scrape_ents24("Reginald D Hunter")
    ].flatten
  end


  def Comedian.scrape_reginald_delicious_hunter
    
    dom = Nokogiri::HTML(open('http://www.reginalddhunter.com/uk-tour-2017/'))

    dom.css('.live-date').map do |html_gig|

      {
        date:              html_gig.at_css('.date').text.strip,
        venue_deets:       "#{html_gig.at_css('.country').text} #{html_gig.at_css('.venue').text}",
        venue_booking_url: html_gig.at_css('a')['href']
      }
    end
  end


  def Comedian.gigs_by_steve_hughes
    
    dom = Nokogiri::HTML(open('http://www.stevehughes.net.au/tour/'))

    dom.css('.eventlist-event').map do |html_gig|
      {
        date:              html_gig.at_css('.event-date').text.strip,
        venue_deets:       html_gig.at_css('.eventlist-title-link').text.strip,
        venue_booking_url: html_gig.at_xpath('//*[text()[contains(., "Tickets Here")]]')['href'] 
      }
    end
  end


  def Comedian.gigs_by_henning_wehn
    [
      Comedian.scrape_ents24("Henning Wehn")
    ].flatten
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


  def Comedian.gigs_by_louis_ck

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


  def Comedian.gigs_by_peter_kay
    [
      Comedian.scrape_peter_kay,
      Comedian.scrape_ents24("Peter Kay")
    ].flatten
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


  def Comedian.gigs_by_omid_djalili
    [
      Comedian.scrape_omid_djalili,
      Comedian.scrape_ents24("Omid Djalili")
    ].flatten
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


  def Comedian.gigs_by_stewart_lee
    [
      Comedian.scrape_stewart_lee
    ].flatten
  end


  # Another horrendous bastard.
  def Comedian.scrape_stewart_lee
    
    dom = Nokogiri::HTML(open('http://www.stewartlee.co.uk/live-dates/'))
    month_and_year = nil

    lines = []
    dom.css('.linkbox').each do |month|

      if my = month.at_css('h6')
        month_and_year = my.text.squish
      end

      month.css('p').each do |p|

        p.children.to_a.split{|tag| tag.name == 'br' }.each do |line|
          lines.push({
            month_and_year: month_and_year,
            line: Nokogiri::HTML::fragment(line.map {|l| l.to_html }.join)
          })
        end

      end
    end

    lines.map do |line|

      stripped = line[:line]
      stripped = stripped.text.squish
      shit_to_remove = ['Content Provider', 'TICKETS', 'SOLD OUT', 'ON SALE SOON', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

      shit_to_remove.each do |shit|
        stripped.gsub! shit, ''
      end

      stripped = stripped.split('–').select{|s| s.to_i == 0 }.join

      {
        date:              DateTime.parse("#{line[:month_and_year]} #{line[:line].text}").to_s,
        venue_deets:       stripped,
        venue_booking_url: line[:line].at_css('a')['href']
      }
    end
  end


  def Comedian.gigs_by_milton_jones
    [
      Comedian.scrape_milton_jones,
      Comedian.scrape_ents24("Milton Jones")
    ].flatten
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


  def Comedian.gigs_by_andy_zaltzman
    [
      Comedian.scrape_andy_zaltzman,
      Comedian.scrape_ents24("Andy Zaltzman")
    ].flatten
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


  def Comedian.gigs_by_russell_brand
    [
      Comedian.scrape_russell_brand,
      Comedian.scrape_ents24("Russell Brand")
    ].flatten
  end


  # "undefined method `text' for nil:NilClass"
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


  def Comedian.gigs_by_tom_allen
    [
      Comedian.scrape_tom_allen,
      Comedian.scrape_ents24("Tom Allen"),
      comedian.scrape_off_the_kerb("Tom Allen"),
    ].flatten
  end
    

  # "404 Not Found"
  def Comedian.scrape_tom_allen

    dom = Nokogiri::HTML(open("http://www.tomindeed.com/shows/"))

    dom.css('.entry-content p').map do |gig|

      venue = gig.text.split("\n")[1]
      city = gig.text.split("\n")[0].split('–')[1].gsub!(' (WITH SUZI RUFFELL)', '')

      {
        date:              gig.text.split("\n")[0].split('–')[0],
        venue_deets:       "#{venue}, #{city}",
        phone:             gig.text.split("\n")[2].gsub!('Box Office: ', ''),
        venue_booking_url: gig.at_css('a')['href']
      }
    end
  end


  def Comedian.gigs_by_billy_connolly
    [
      Comedian.scrape_billy_connolly,
      Comedian.scrape_ents24("Billy Connolly")
    ].flatten
  end


  def Comedian.scrape_billy_connolly

    dom = Nokogiri::HTML(open('http://billyconnolly.com/tour'))

    dom.css('.bullet li').map do |gig|

      {
        date:              gig.at_css('strong').text.squish,
        venue_deets:       gig.children[1].text.squish,
        venue_booking_url: gig.at_css('a:nth-child(2)')['href']
      }
    end
  end


  def Comedian.gigs_by_jack_whitehall
    [
      Comedian.scrape_jack_whitehall,
      Comedian.scrape_ents24('Jack Whitehall')
    ].flatten
  end


  def Comedian.scrape_jack_whitehall

    dom = Nokogiri::HTML(open('https://www.jackwhitehall.com/'))

    dom.css('.live-date.accordion').map do |gig|

      venue = gig.at_css('.live-date-item.venue').text.squish
      city = gig.at_css('.live-date-item.city').text.squish

      {
        date:                     gig.at_css('.live-date-item.date').text.squish,
        venue_deets:              "#{venue} #{city}",
        venue_booking_url:        gig.at_css('.button1') ? gig.at_css('.button1')['href'] : '',
        ticketmaster_booking_url: gig.at_css('.button2') ? gig.at_css('.button2')['href'] : ''
      }
    end
  end


  def Comedian.gigs_by_adam_hills
    [
      Comedian.scrape_off_the_kerb("Adam Hills"),
      Comedian.scrape_ents24("Adam Hills")
    ].flatten
  end


  def Comedian.gigs_by_andy_parsons
    [
      Comedian.scrape_off_the_kerb("Andy Parsons"),
      Comedian.scrape_ents24("Andy Parsons")
    ].flatten
  end


  def Comedian.gigs_by_charlie_baker
    [
      Comedian.scrape_off_the_kerb("Charlie Baker"),
      Comedian.scrape_ents24("Charlie Baker"),
    ].flatten
  end


  def Comedian.gigs_by_jeremy_hardy
    [
      Comedian.scrape_off_the_kerb("Jeremy Hardy"),
      Comedian.scrape_ents24("Jeremy Hardy")
    ].flatten
  end


  def Comedian.gigs_by_joel_dommett
    [
      Comedian.scrape_off_the_kerb("Joel Dommett"),
      Comedian.scrape_ents24("Joel Dommett")
    ].flatten
  end


  def Comedian.gigs_by_mark_steel
    [
      Comedian.scrape_off_the_kerb("Mark Steel"),
      Comedian.scrape_ents24("Mark Steel")
    ].flatten
  end


  def Comedian.gigs_by_phill_jupitus
    [
      Comedian.scrape_off_the_kerb("Phill Jupitus"),
      Comedian.scrape_ents24("Phill Jupitus")
    ].flatten
  end


  def Comedian.gigs_by_rich_hall
    [
      Comedian.scrape_off_the_kerb("Rich Hall"),
      Comedian.scrape_ents24("Rich Hall")
    ].flatten
  end


  def Comedian.gigs_by_rob_beckett
    [
      Comedian.scrape_off_the_kerb("Rob Beckett"),
      Comedian.scrape_ents24("Rob Beckett")
    ].flatten
  end


  def Comedian.gigs_by_russell_kane
    [
      Comedian.scrape_off_the_kerb("Russell Kane"),
      Comedian.scrape_ents24("Russell Kane")
    ].flatten
  end


  def Comedian.gigs_by_seann_walsh
    [
      Comedian.scrape_off_the_kerb("Seann Walsh"),
      Comedian.scrape_ents24("Seann Walsh")
    ].flatten
  end


  def Comedian.gigs_by_shappi_khorsandi
    [
      Comedian.scrape_off_the_kerb("Shappi Khorsandi"),
      Comedian.scrape_ents24("Shappi Khorsandi")
    ].flatten
  end


  def Comedian.gigs_by_suzi_ruffell
    [
      Comedian.scrape_off_the_kerb("Suzi Ruffell"),
      Comedian.scrape_ents24("Suzi Ruffell")
    ].flatten
  end


  def Comedian.gigs_by_aisling_bea
    {}
  end


  def Comedian.gigs_by_lucy_porter
    [
      Comedian.scrape_ents24("Lucy Porter")
    ].flatten
  end


  def Comedian.gigs_by_nina_conti
    {}
  end


  def Comedian.gigs_by_sean_lock
    [
      Comedian.scrape_ents24("Sean Lock"),
      Comedian.scrape_off_the_kerb("Sean Lock"),
    ].flatten
  end


  def Comedian.gigs_by_rory_bremner
    Comedian.scrape_ents24 "Rory Bremner"
  end


  # So far this is the only method with a difference between the comedian's name and what I call ents24 with. "Sir". Ents24's name for the gentleman is "Sir Ken Dodd", so we scrape it with that.
  def Comedian.gigs_by_ken_dodd
    Comedian.scrape_ents24 "Sir Ken Dodd"
  end


  def Comedian.gigs_by_brian_conley
    Comedian.scrape_ents24 "Brian Conley"
  end


  def Comedian.gigs_by_joe_lycett
    Comedian.scrape_ents24 "Joe Lycett"
  end


  def Comedian.gigs_by_romesh_ranganathan
    Comedian.scrape_ents24 "Romesh Ranganathan"
  end


  def Comedian.gigs_by_danny_baker
    Comedian.scrape_ents24 "Danny Baker"
  end


  def Comedian.gigs_by_jethro
    Comedian.scrape_ents24 "Jethro"
  end


  def Comedian.gigs_by_roy_chubby_brown
    Comedian.scrape_ents24 'Roy "Chubby" Brown'
  end


  def Comedian.gigs_by_jack_dee
    Comedian.scrape_ents24 "Jack Dee"
  end


  def Comedian.gigs_by_keith_farnan
    [
      Comedian.scrape_ents24("Keith Farnan")
    ].flatten
  end


  def Comedian.gigs_by_max_boyce
    Comedian.scrape_ents24 "Max Boyce"
  end


  def Comedian.gigs_by_james_acaster
    Comedian.scrape_ents24 "James Acaster"
  end


  def Comedian.gigs_by_angelos_epithemiou
    Comedian.scrape_ents24 "Angelos Epithemiou"
  end


  def Comedian.gigs_by_ruby_wax
    Comedian.scrape_ents24 "Ruby Wax"
  end


  def Comedian.gigs_by_jim_davidson
    Comedian.scrape_ents24 "Jim Davidson"
  end


  def Comedian.gigs_by_john_bishop
    Comedian.scrape_ents24 "John Bishop"
  end


  def Comedian.gigs_by_jon_culshaw
    Comedian.scrape_ents24 "Jon Culshaw"
  end


  def Comedian.gigs_by_joe_longthorne
    Comedian.scrape_ents24 "Joe Longthorne"
  end


  def Comedian.gigs_by_ricky_gervais
    Comedian.scrape_ents24 "Ricky Gervais"
  end


  def Comedian.gigs_by_lee_nelson
    Comedian.scrape_ents24 "Lee Nelson"
  end


  def Comedian.gigs_by_jasper_carrot
    Comedian.scrape_ents24 "Jasper Carrot"
  end


  def Comedian.gigs_by_tom_stade
    Comedian.scrape_ents24 "Tom Stade"
  end


  def Comedian.gigs_by_tim_key
    Comedian.scrape_ents24 "Tim Key"
  end


  def Comedian.gigs_by_john_shuttleworth
    Comedian.scrape_ents24 "John Shuttleworth"
  end


  def Comedian.gigs_by_cannon_and_ball
    Comedian.scrape_ents24 "Cannon and Ball"
  end


  def Comedian.gigs_by_bianca_del_rio
    Comedian.scrape_ents24 "Bianca Del Rio"
  end


  def Comedian.gigs_by_jerry_sadowitz
    Comedian.scrape_ents24 "Jerry Sadowitz"
  end


  def Comedian.gigs_by_luisa_omielan
    Comedian.scrape_ents24 "Luisa Omielan"
  end


  def Comedian.gigs_by_des_o_connor
    Comedian.scrape_ents24 "Des OConnor"
  end


  def Comedian.gigs_by_brian_cox
    Comedian.scrape_ents24 "Professor Brian Cox"
  end


  def Comedian.gigs_by_limmy
    Comedian.scrape_ents24 "Limmy"
  end


  def Comedian.gigs_by_stewart_francis
    Comedian.scrape_ents24 "Stewart Francis"
  end


  def Comedian.gigs_by_jimmy_jones
    Comedian.scrape_ents24 "Jimmy Jones"
  end


  def Comedian.gigs_by_nick_helm
    Comedian.scrape_ents24 "Nick Helm"
  end


  def Comedian.gigs_by_miles_jupp
    Comedian.scrape_ents24 "Miles Jupp"
  end


  def Comedian.gigs_by_doc_brown
    Comedian.scrape_ents24 "Doc Brown"
  end


  def Comedian.gigs_by_jamali_maddix
    Comedian.scrape_ents24 "Jamali Maddix"
  end


  def Comedian.gigs_by_bridget_christie
    Comedian.scrape_ents24 "Bridget Christie"
  end


  def Comedian.gigs_by_joe_pasquale
    Comedian.scrape_ents24 "Joe Pasquale"
  end


  def Comedian.gigs_by_billy_pearce
    Comedian.scrape_ents24 "Billy Pearce"
  end


  def Comedian.gigs_by_basketmouth
    Comedian.scrape_ents24 "Basketmouth"
  end


  def Comedian.gigs_by_tom_wrigglesworth
    Comedian.scrape_ents24 "Tom Wrigglesworth"
  end


  def Comedian.gigs_by_al_murray
    Comedian.scrape_ents24 "Al Murray"
  end


  def Comedian.gigs_by_jimmy_tarbuck
    Comedian.scrape_ents24 "Jimmy Tarbuck OBE"
  end


  def Comedian.gigs_by_ardal_o_hanlon
    Comedian.scrape_ents24 "Ardal Ohanlon"
  end


  def Comedian.gigs_by_paul_sinha
    Comedian.scrape_ents24 "Paul Sinha"
  end


  def Comedian.gigs_by_count_arthur_strong
    Comedian.scrape_ents24 "Count Arthur Strong"
  end


  def Comedian.gigs_by_luke_kempner
    Comedian.scrape_ents24 "Luke Kempner"
  end


  def Comedian.gigs_by_simon_evans
    [
      Comedian.scrape_ents24("Simon Evans"),
      Comedian.scrape_off_the_kerb("Simon Evans"),
    ].flatten
  end


  def Comedian.gigs_by_mike_doyle
    Comedian.scrape_ents24 "Mike Doyle"
  end


  def Comedian.gigs_by_ceri_dupree
    Comedian.scrape_ents24 "Ceri Dupree"
  end


  def Comedian.gigs_by_chris_ramsey
    Comedian.scrape_ents24 "Chris Ramsey"
  end


  def Comedian.gigs_by_sue_perkins
    Comedian.scrape_ents24 "Sue Perkins"
  end


  def Comedian.gigs_by_bobby_davro
    Comedian.scrape_ents24 "Bobby Davro"
  end


  def Comedian.gigs_by_david_baddiel
    Comedian.scrape_ents24 "David Baddiel"
  end


  def Comedian.gigs_by_andy_hamilton
    Comedian.scrape_ents24 "Andy Hamilton"
  end


  def Comedian.gigs_by_nathon_caton
    Comedian.scrape_ents24 "Nathan Caton"
  end


  def Comedian.gigs_by_david_o_doherty
    Comedian.scrape_ents24 "David ODoherty"
  end


  def Comedian.gigs_by_rob_brydon
    Comedian.scrape_ents24 "Rob Brydon"
  end


  def Comedian.gigs_by_adam_buxton
    Comedian.scrape_ents24 "Adam Buxton"
  end


  def Comedian.gigs_by_penn_and_teller
    Comedian.scrape_ents24 "Penn And Teller"
  end


  def Comedian.gigs_by_patrick_monahan
    Comedian.scrape_ents24 "Patrick Monahan"
  end


  def Comedian.gigs_by_gervase_phinn
    Comedian.scrape_ents24 "Gervase Phinn"
  end


  def Comedian.gigs_by_mark_thomas
    Comedian.scrape_ents24 "Mark Thomas"
  end


  def Comedian.gigs_by_hal_cruttenden
    Comedian.scrape_ents24 "Hal Cruttenden"
  end


  def Comedian.gigs_by_john_robins
    Comedian.scrape_ents24 "John Robins"
  end


  def Comedian.gigs_by_the_rubberbandits
    Comedian.scrape_ents24 "The Rubberbandits"
  end


  def Comedian.gigs_by_the_barron_knights
    Comedian.scrape_ents24 "The Barron Knights"
  end


  def Comedian.gigs_by_andrew_lawrence
    Comedian.scrape_ents24 "Andrew Lawrence"
  end


  def Comedian.gigs_by_johnny_vegas
    Comedian.scrape_ents24 "Johnny Vegas"
  end


  def Comedian.gigs_by_kevin_bloody_wilson
    Comedian.scrape_ents24 "Kevin Bloody Wilson"
  end


  def Comedian.gigs_by_barry_cryer
    Comedian.scrape_ents24 "Barry Cryer"
  end


  def Comedian.gigs_by_gary_delaney
    Comedian.scrape_ents24 "Gary Delaney"
  end


  def Comedian.gigs_by_mae_martin
    Comedian.scrape_ents24 "Mae Martin"
  end


  def Comedian.gigs_by_abi_roberts
    Comedian.scrape_ents24 "Abi Roberts"
  end


  def Comedian.gigs_by_richard_blackwood
    Comedian.scrape_ents24 "Richard Blackwood"
  end


  def Comedian.gigs_by_stephen_k_amos
    Comedian.scrape_ents24 "Stephen K Amos"
  end


  def Comedian.gigs_by_marcus_brigstocke
    Comedian.scrape_ents24 "Marcus Brigstocke"
  end


  def Comedian.gigs_by_hardeep_singh_kohli
    Comedian.scrape_ents24 "Hardeep Singh Kohli"
  end


  def Comedian.gigs_by_the_grumbleweeds
    Comedian.scrape_ents24 "The Grumbleweeds"
  end


  def Comedian.gigs_by_paul_zerdin
    Comedian.scrape_ents24 "Paul Zerdin"
  end


  def Comedian.gigs_by_josie_long
    Comedian.scrape_ents24 "Josie Long"
  end


  def Comedian.gigs_by_sara_pascoe
    Comedian.scrape_ents24 "Sara Pascoe"
  end


  def Comedian.gigs_by_richard_herring
    Comedian.scrape_ents24 "Richard Herring"
  end


  def Comedian.gigs_by_richard_digance
    Comedian.scrape_ents24 "Richard Digance"
  end


  def Comedian.gigs_by_pam_ayres
    Comedian.scrape_ents24 "Pam Ayres"
  end


  def Comedian.gigs_by_kojo
    Comedian.scrape_ents24 "Kojo"
  end


  def Comedian.gigs_by_phil_wang
    Comedian.scrape_ents24 "Phil Wang"
  end


  def Comedian.gigs_by_brendon_burns
    Comedian.scrape_ents24 "Brendon Burns"
  end


  def Comedian.gigs_by_kieran_hodgson
    Comedian.scrape_ents24 "Kieran Hodgson"
  end


  def Comedian.gigs_by_kerry_godliman
    Comedian.scrape_ents24 "Kerry Godliman"
  end


  def Comedian.gigs_by_susan_calman
    Comedian.scrape_ents24 "Susan Calman"
  end


  def Comedian.gigs_by_jonathan_pie
    Comedian.scrape_ents24 "Jonathan Pie"
  end


  def Comedian.gigs_by_ivo_graham
    Comedian.scrape_ents24 "Ivo Graham"
  end


  # "404 Not Found"
  def Comedian.gigs_by_tudor_owen
    Comedian.scrape_ents24 "Tudor Owen"
  end


  def Comedian.gigs_by_zoe_lyons
    Comedian.scrape_ents24 "Zoe Lyons"
  end


  def Comedian.gigs_by_tony_law
    Comedian.scrape_ents24 "Tony Law"
  end


  # "404 Not Found"
  def Comedian.gigs_by_craig_hill
    Comedian.scrape_ents24 "Craig Hill"
  end


  def Comedian.gigs_by_bob_mills
    Comedian.scrape_ents24 "Bob Mills"
  end


  def Comedian.gigs_by_conal_gallen
    Comedian.scrape_ents24 "Conal Gallen"
  end


  def Comedian.gigs_by_stavros_flatley
    Comedian.scrape_ents24 "Stavros Flatley"
  end


  def Comedian.gigs_by_jimeoin
    Comedian.scrape_ents24 "Jimeoin"
  end


  def Comedian.gigs_by_mick_miller
    Comedian.scrape_ents24 "Mick Miller"
  end


  def Comedian.gigs_by_dave_spikey
    Comedian.scrape_ents24 "Dave Spikey"
  end


  def Comedian.gigs_by_grant_stott
    Comedian.scrape_ents24 "Grant Stott"
  end


  def Comedian.gigs_by_jake_o_kane
    Comedian.scrape_ents24 "Jake OKane"
  end


  def Comedian.gigs_by_cecilia_delatori
    Comedian.scrape_ents24 "Cecilia Delatori"
  end


  def Comedian.gigs_by_arthur_smith
    Comedian.scrape_ents24 "Arthur Smith"
  end


  def Comedian.gigs_by_tom_green
    Comedian.scrape_ents24 "Tom Green"
  end


  def Comedian.gigs_by_alan_davies
    Comedian.scrape_ents24 "Alan Davies"
  end


  def Comedian.gigs_by_brennan_reece
    Comedian.scrape_ents24 "Brennan Reece"
  end


  def Comedian.gigs_by_mrs_barbara_nice_janice_connolly
    Comedian.scrape_ents24 "Mrs Barbara Nice (Janice Connolly)"
  end


  def Comedian.gigs_by_paul_foot
    Comedian.scrape_ents24 "Paul Foot"
  end


  def Comedian.rosie_and_rosie
    Comedian.scrape_ents24 "Rosie And Rosie"
  end


  def Comedian.gigs_by_john_challis
    Comedian.scrape_ents24 "John Challis"
  end


  def Comedian.gigs_by_imran_yusuf
    Comedian.scrape_ents24 "Imran Yusuf"
  end


  def Comedian.gigs_by_richard_gadd
    Comedian.scrape_ents24 "Richard Gadd"
  end


  def Comedian.gigs_by_dillie_keane
    Comedian.scrape_ents24 "Dillie Keane"
  end


  def Comedian.gigs_by_mr_b_the_gentleman_rhymer
    Comedian.scrape_ents24 "Mr B The Gentleman Rhymer"
  end


  def Comedian.gigs_by_phil_beer_band
    Comedian.scrape_ents24 "Phil Beer Band"
  end


  def Comedian.gigs_by_comedy_club_4_kids
    Comedian.scrape_ents24 "Comedy Club 4 Kids"
  end


  def Comedian.gigs_by_des_clarke
    Comedian.scrape_ents24 "Des Clarke"
  end


  def Comedian.gigs_by_larry_dean
    Comedian.scrape_ents24 "Larry Dean"
  end


  def Comedian.gigs_by_the_manc_lads
    Comedian.scrape_ents24 "The Manc Lads"
  end


  def Comedian.gigs_by_josh_howie
    Comedian.scrape_ents24 "Josh Howie"
  end


  def Comedian.gigs_by_brian_gittins
    Comedian.scrape_ents24 "Brian Gittins"
  end


  def Comedian.gigs_by_jason_cook
    Comedian.scrape_ents24 "Jason Cook"
  end


  def Comedian.gigs_by_sofie_hagen
    Comedian.scrape_ents24 "Sofie Hagen"
  end


  def Comedian.gigs_by_toby_foster
    Comedian.scrape_ents24 "Toby Foster"
  end


  def Comedian.gigs_by_phil_hammond
    [
      Comedian.scrape_ents24("Dr Phil Hammond"),
    ].flatten
  end


  def Comedian.gigs_by_yuriko_kotani
    Comedian.scrape_ents24 "Yuriko Kotani"
  end


  def Comedian.gigs_by_barry_from_watford
    Comedian.scrape_ents24 "Barry From Watford"
  end


  def Comedian.gigs_by_lee_hurst
    Comedian.scrape_ents24 "Lee Hurst"
  end


  def Comedian.gigs_by_al_porter
    Comedian.scrape_ents24 "Al Porter"
  end


  def Comedian.gigs_by_simon_munnery
    Comedian.scrape_ents24 "Simon Munnery"
  end


  def Comedian.gigs_by_janey_godley
    Comedian.scrape_ents24 "Janey Godley"
  end


  def Comedian.gigs_by_marcel_lucont
    Comedian.scrape_ents24 "Marcel Lucont"
  end


  def Comedian.gigs_by_mark_cooper_jones
    Comedian.scrape_ents24 "Mark Cooper-Jones"
  end


  def Comedian.gigs_by_jenny_eclair
    Comedian.scrape_ents24 "Jenny Eclair"
  end


  def Comedian.gigs_by_shazia_mirza
    Comedian.scrape_ents24 "Shazia Mirza"
  end


  def Comedian.gigs_by_dane_j_baptiste
    [
      Comedian.scrape_ents24("Dane J Baptiste")
      ].flatten
  end


  def Comedian.gigs_by_jeff_innocent
    Comedian.scrape_ents24 "Jeff Innocent"
  end


  def Comedian.gigs_by_david_walliams
    Comedian.scrape_ents24 "David Walliams"
  end


  def Comedian.gigs_by_bobby_mair
    Comedian.scrape_ents24 "Bobby Mair"
  end


  def Comedian.gigs_by_robin_ince
    Comedian.scrape_ents24 "Robin Ince"
  end


  def Comedian.gigs_by_nathan_caton
    Comedian.scrape_ents24 "Nathan Caton"
  end


  def Comedian.gigs_by_ellie_taylor
    [
      Comedian.scrape_ents24("Ellie Taylor")
    ].flatten
  end


  def Comedian.gigs_by_ed_gamble
    [
      Comedian.scrape_ents24("Ed Gamble")
    ].flatten
  end


  def Comedian.gigs_by_jo_caulfield
    [
      Comedian.scrape_ents24("Jo Caulfield")
    ].flatten
  end


  def Comedian.gigs_by_abandoman
    [
      Comedian.scrape_ents24("Abandoman")
    ].flatten
  end


  def Comedian.gigs_by_stuart_goldsmith
    [
      Comedian.scrape_ents24("Stuart Goldsmith")
    ].flatten
  end


  def Comedian.gigs_by_raymond_mearns
    [
      Comedian.scrape_ents24("Raymond Mearns")
    ].flatten
  end


  def Comedian.gigs_by_geoff_norcott
    [
      Comedian.scrape_ents24("Geoff Norcott")
    ].flatten
  end


  def Comedian.gigs_by_dave_gorman
    [
      Comedian.scrape_ents24("Dave Gorman")
    ].flatten
  end


  def Comedian.gigs_by_kane_brown
    [
      Comedian.scrape_ents24("Kane Brown")
    ].flatten
  end


  def Comedian.gigs_by_slim
    [
      Comedian.scrape_ents24("Slim")
    ].flatten
  end


  def Comedian.gigs_by_axel_blake
    [
      Comedian.scrape_ents24("Axel Blake")
    ].flatten
  end


  def Comedian.gigs_by_kojo
    [
      Comedian.scrape_ents24("Kojo")
    ].flatten
  end


  def Comedian.gigs_by_joe_wells
    [
      Comedian.scrape_ents24("Joe Wells")
    ].flatten
  end


  def Comedian.gigs_by_the_lancashire_hotpots
    [
      Comedian.scrape_ents24("The Lancashire Hotpots")
    ].flatten
  end


  def Comedian.gigs_by_justin_moorhouse
    [
      Comedian.scrape_ents24("Justin Moorhouse")
    ].flatten
  end


  def Comedian.gigs_by_tommy_tiernan
    [
      Comedian.scrape_ents24("Tommy Tiernan")
    ].flatten
  end


  def Comedian.gigs_by_iain_stirling
    [
      Comedian.scrape_ents24("Iain Stirling")
    ].flatten
  end


  def Comedian.gigs_by_phil_tufnell
    [
      Comedian.scrape_ents24("Phil Tufnell")
    ].flatten
  end


  def Comedian.gigs_by_lloyd_griffith
    [
      Comedian.scrape_ents24("Lloyd Griffith")
    ].flatten
  end


  def Comedian.gigs_by_puppetry_of_the_penis
    [
      Comedian.scrape_ents24("Puppetry of the Penis")
    ].flatten
  end


  def Comedian.gigs_by_the_spooky_mens_chorale
    [
      Comedian.scrape_ents24("The Spooky Mens Chorale")
    ].flatten
  end


  def Comedian.gigs_by_wells_comedy_festival
    [
      Comedian.scrape_ents24("Wells Comedy Festival")
    ].flatten
  end


  def Comedian.gigs_by_phil_nichol
    [
      Comedian.scrape_ents24("Phil Nichol")
    ].flatten
  end


  def Comedian.gigs_by_colin_cole
    [
      Comedian.scrape_ents24("Colin Cole")
    ].flatten
  end


  def Comedian.gigs_by_jarred_christmas
    [
      Comedian.scrape_ents24("Jarred Christmas")
    ].flatten
  end


  def Comedian.gigs_by_ted_ilyaz
    [
      Comedian.scrape_ents24("Ted Ilyaz")
    ].flatten
  end


  def Comedian.gigs_by_fred_macaulay
    [
      Comedian.scrape_ents24("Fred MacAulay")
    ].flatten
  end


  def Comedian.gigs_by_adam_kay
    [
      Comedian.scrape_ents24("Adam Kay")
    ].flatten
  end


  def Comedian.gigs_by_ali_cook
    [
    ].flatten
  end


  def Comedian.gigs_by_the_dolls
    [
      Comedian.scrape_ents24("The Dolls")
    ].flatten
  end


  def Comedian.gigs_by_matt_forde
    [
      Comedian.scrape_ents24("Matt Forde")
    ].flatten
  end


  def Comedian.gigs_by_john_kearns
    [
      Comedian.scrape_ents24("John Kearns")
    ].flatten
  end


  def Comedian.gigs_by_the_noise_next_door
    [
      Comedian.scrape_ents24("The Noise Next Door")
    ].flatten
  end


  def Comedian.gigs_by_mc_devvo
    [
      Comedian.scrape_ents24("MC Devvo")
    ].flatten
  end


  def Comedian.gigs_by_tiffany_stevenson
    [
      Comedian.scrape_ents24("Tiffany Stevenson")
    ].flatten
  end


  def Comedian.gigs_by_carl_hutchinson
    [
      Comedian.scrape_ents24("Carl Hutchinson")
    ].flatten
  end


  def Comedian.gigs_by_the_alternative_comedy_memorial_society
    [
      Comedian.scrape_ents24("ACMS The Alternative Comedy Memorial Society")
    ].flatten
  end


  def Comedian.gigs_by_jen_brister
    [
      Comedian.scrape_ents24("Jen Brister")
    ].flatten
  end


  def Comedian.gigs_by_the_comedy_store_players
    [
      Comedian.scrape_ents24("The Comedy Store Players")
    ].flatten
  end


  def Comedian.gigs_by_neil_delamere
    [
      Comedian.scrape_ents24("Neil Delamere")
    ].flatten
  end


  def Comedian.gigs_by_foil_arms_and_hog
    [
      Comedian.scrape_ents24("Foil Arms And Hog"),
      Comedian.scrape_off_the_kerb("Foil Arms And Hog")
    ].flatten
  end


  def Comedian.gigs_by_pete_johansson
    [
      Comedian.scrape_ents24("Pete Johansson")
    ].flatten
  end


  def Comedian.gigs_by_adam_hess
    [
      Comedian.scrape_ents24("Adam Hess")
    ].flatten
  end


  def Comedian.gigs_by_mik_artistik_s_ego_trip
    [
      Comedian.scrape_ents24("Mik Artistiks Ego Trip")
    ].flatten
  end


  def Comedian.gigs_by_pam_ann
    [
      Comedian.scrape_ents24("Pam Ann")
    ].flatten
  end


  def Comedian.gigs_by_circus_hilarious
    [
      Comedian.scrape_ents24("Circus Hilarious")
    ].flatten
  end


  def Comedian.gigs_by_fizzog_productions
    [
      Comedian.scrape_ents24("Fizzog Productions")
    ].flatten
  end


  def Comedian.gigs_by_barry_dodds
    [
      Comedian.scrape_ents24("Barry Dodds")
    ].flatten
  end


  def Comedian.gigs_by_micky_bartlett
    [
      Comedian.scrape_ents24("Micky Bartlett")
    ].flatten
  end


  def Comedian.gigs_by_kevin_mcaleer
    [
      Comedian.scrape_ents24("Kevin McAleer")
    ].flatten
  end


  def Comedian.gigs_by_nish_kumar
    [
      Comedian.scrape_ents24("Nish Kumar")
    ].flatten
  end


  def Comedian.gigs_by_andy_askins
    [
      Comedian.scrape_ents24("Andy Askins")
    ].flatten
  end


  def Comedian.gigs_by_ashley_blaker
    [
      Comedian.scrape_ents24("Ashley Blaker")
    ].flatten
  end


  def Comedian.gigs_by_adam_bloom
    [
      Comedian.scrape_ents24("Adam Bloom")
    ].flatten
  end


  def Comedian.gigs_by_greg_proops
    [
      Comedian.scrape_greg_proops,
      Comedian.scrape_ents24("Greg Proops")
    ].flatten
  end


  def Comedian.scrape_greg_proops
    []
  end


  def Comedian.gigs_by_morgan_and_west
    [
      Comedian.scrape_ents24("Morgan and West")
    ].flatten
  end


  def Comedian.gigs_by_katy_brand
    [
      Comedian.scrape_ents24("Katy Brand")
    ].flatten
  end


  def Comedian.gigs_by_nicholas_parsons
    [
      Comedian.scrape_ents24("Nicholas Parsons")
    ].flatten
  end


  def Comedian.gigs_by_carl_donnelly
    [
      Comedian.scrape_ents24("Carl Donnelly")
    ].flatten
  end


  def Comedian.gigs_by_andy_robinson
    [
      Comedian.scrape_ents24("Andy Robinson")
    ].flatten
  end


  def Comedian.gigs_by_mishka_shubaly
    [
      Comedian.scrape_ents24("Mishka Shubaly")
    ].flatten
  end


  def Comedian.gigs_by_scott_capurro
    [
      Comedian.scrape_ents24("scott_capurro")
    ].flatten
  end


  def Comedian.gigs_by_eddie_the_eagle_edwards
    [
      Comedian.scrape_ents24("Eddie 'The Eagle' Edwards")
    ].flatten
  end


  def Comedian.gigs_by_meryl_o_rourke
    [
      Comedian.scrape_ents24("Meryl O'Rourke")
    ].flatten
  end


  def Comedian.gigs_by_funmbi_omotayo
    [
      Comedian.scrape_ents24("Funmbi Omotayo")
    ].flatten
  end


  def Comedian.gigs_by_terry_alderton
    [
      Comedian.scrape_ents24("Terry Alderton")
    ].flatten
  end


  def Comedian.gigs_by_junior_simpson
    [
      Comedian.scrape_ents24("Junior Simpson")
    ].flatten
  end


  def Comedian.gigs_by_sean_mcloughlin
    [
      Comedian.scrape_ents24("Sean McLoughlin")
    ].flatten
  end


  def Comedian.gigs_by_alistair_barrie
    [
      Comedian.scrape_ents24("Alistair Barrie")
    ].flatten
  end


  def Comedian.gigs_by_jeff_dunham
    [
      Comedian.scrape_ents24("Jeff Dunham")
    ].flatten
  end


  def Comedian.gigs_by_rob_rouse
    [
      Comedian.scrape_ents24("Rob Rouse")
    ].flatten
  end


  def Comedian.gigs_by_roger_monkhouse
    [
      Comedian.scrape_ents24("Roger Monkhouse")
    ].flatten
  end


  def Comedian.gigs_by_claire_parker
    [
      Comedian.scrape_ents24("Claire Parker")
    ].flatten
  end


  def Comedian.gigs_by_alex_kealy
    [
      Comedian.scrape_ents24("Alex Kealy")
    ].flatten
  end


  def Comedian.gigs_by_jonny_awsum
    [
      Comedian.scrape_ents24("Jonny Awsum")
    ].flatten
  end


  def Comedian.gigs_by_iain_connell_and_robert_florence
    [
      Comedian.scrape_ents24("Iain Connell and Robert Florence")
    ].flatten
  end


  def Comedian.gigs_by_mitch_benn
    [
      Comedian.scrape_ents24("Mitch Benn")
    ].flatten
  end


  def Comedian.gigs_by_john_ryan
    [
      Comedian.scrape_ents24("John Ryan")
    ].flatten
  end


  def Comedian.gigs_by_john_hegley
    [
      Comedian.scrape_ents24("John Hegley")
    ].flatten
  end


  def Comedian.gigs_by_the_houghton_weavers
    [
      Comedian.scrape_ents24("The Houghton Weavers")
    ].flatten
  end


  def Comedian.gigs_by_professor_elemental
    [
      Comedian.scrape_ents24("Professor Elemental")
    ].flatten
  end


  def Comedian.gigs_by_jessica_fostekew
    [
      Comedian.scrape_ents24("Jessica Fostekew")
    ].flatten
  end


  def Comedian.gigs_by_tanyalee_davis
    [
      Comedian.scrape_ents24("Tanyalee Davis")
    ].flatten
  end


  def Comedian.gigs_by_pete_firman
    [
      Comedian.scrape_ents24("Pete Firman")
    ].flatten
  end


  def Comedian.gigs_by_laura_lexx
    [
      Comedian.scrape_ents24("Laura Lexx")
    ].flatten
  end


  def Comedian.gigs_by_edward_aczel
    [
      Comedian.scrape_ents24("Edward Aczel")
    ].flatten
  end


  def Comedian.gigs_by_sophie_willan
    [
      Comedian.scrape_ents24("Sophie Willan")
    ].flatten
  end


  def Comedian.gigs_by_rachel_parris
    [
      Comedian.scrape_ents24("Rachel Parris")
    ].flatten
  end


  def Comedian.gigs_by_seymour_mace
    [
      Comedian.scrape_ents24("Seymour Mace")
    ].flatten
  end


  def Comedian.gigs_by_rob_deering
    [
      Comedian.scrape_ents24("Rob Deering")
    ].flatten
  end


  def Comedian.gigs_by_josh_howie
    [
      Comedian.scrape_ents24("Josh Howie")
    ].flatten
  end


  def Comedian.gigs_by_angela_barnes
    [
      Comedian.scrape_ents24("Angela Barnes")
    ].flatten
  end


  def Comedian.gigs_by_nick_revell
    [
      Comedian.scrape_ents24("Nick Revell")
    ].flatten
  end


  def Comedian.gigs_by_rik_carranza
    [
      Comedian.scrape_ents24("Rik Carranza")
    ].flatten
  end


  def Comedian.gigs_by_alfie_moore
    [
      Comedian.scrape_ents24("Alfie Moore")
    ].flatten
  end


  def Comedian.gigs_by_michael_fabbri
    [
      Comedian.scrape_ents24("Michael Fabbri")
    ].flatten
  end


  def Comedian.gigs_by_the_amazing_bubble_man
    [
      Comedian.scrape_ents24("The Amazing Bubble Man")
    ].flatten
  end


  def Comedian.gigs_by_andy_wilkinson
    [
      Comedian.scrape_ents24("Andy Wilkinson")
    ].flatten
  end


  def Comedian.gigs_by_rudi_lickwood
    [
      Comedian.scrape_ents24("Rudy Lickwood")
    ].flatten
  end


  def Comedian.gigs_by_mike_gunn
    [
      Comedian.scrape_ents24("Mike Gunn")
    ].flatten
  end


  def Comedian.gigs_by_paul_mccaffrey
    [
      Comedian.scrape_ents24("Paul McCaffrey")
    ].flatten
  end


  def Comedian.gigs_by_scott_gibson
    [
      Comedian.scrape_ents24("Scott Gibson")
    ].flatten
  end


  def Comedian.gigs_by_tom_glover
    [
      Comedian.scrape_ents24("Tom Glover")
    ].flatten
  end


  def Comedian.gigs_by_graffiti_classics
    [
      Comedian.scrape_ents24("Graffiti Classics")
    ].flatten
  end


  def Comedian.gigs_by_phil_ellis
    [
      Comedian.scrape_ents24("Phil Ellis")
    ].flatten
  end


  def Comedian.gigs_by_simon_amstell
    [
      Comedian.scrape_ents24("Simon Amstell"),
      Comedian.scrape_simon_amstell
    ].flatten
  end


  def Comedian.scrape_simon_amstell

    dom = Nokogiri::HTML(open('https://www.simonamstell.com/tour-1'))

    dom.css('.main-content [data-block-type="53"]:not(:last-child)').map do |gig|

      text = gig.text.squish.split(',')

      {
        date:              text.last,
        venue_deets:       "#{text[0]}, #{text[1]}",
        venue_booking_url: gig.at_css('a')['href']
      }
    end
  end


  def Comedian.scrape_off_the_kerb(comedian_name)

    dom = Nokogiri::HTML(open("http://offthekerb.co.uk/on-tour/?on_tour_artist=#{comedian_name.gsub(' ', '+')}"))

    dom.css('#on_tour_results li').map do |gig|

      city = gig.at_css('.event_title').text.squish.gsub!("#{comedian_name.upcase} IN", '')
      venue = gig.at_css('.location').text.squish

      {
        date:              gig.at_css('.live').text.squish.gsub!('LIVE: ', ''),
        venue_deets:       "#{venue} #{city}",
        phone:             gig.at_css('.telephone').text.squish.gsub!('Box Office: ', ''),
        venue_booking_url: gig.at_css('.book_tickets a')['href']
      }
    end
  end


  def Comedian.scrape_ents24(comedian_name)

    dom = Nokogiri::HTML(open("https://www.ents24.com/uk/tour-dates/#{comedian_name.parameterize}"))

    dom.css('#event-list .event-list-item-container').map do |html_gig|

      {
        date:              html_gig.at_css('.event-date').text.squish,
        venue_deets:       html_gig.at_css('.event-location').text.squish,
        venue_booking_url: html_gig.at_css('a.event-list-item')['href']
      }
    end
  end

  # Receive a whole bunch of freshly scraped gigs. If they don't exist, create them.
  def create_gigs(gigs = {})

    created = { venues: 0, gigs: 0, spots: 0 }

    gigs.each do |input_gig|

      # First, for each of our gigs, we need a venue to host it at. Query our Venues
      # table for it, or if it doesn't exist, create it.
      venue, venue_created = Venue.find_or_create_by(input_gig)
      created[:venues] += 1 if venue_created

      # Great. Now we've got our found/created venue. Next, we query for the existence
      # of our gig too. For more info on how we test whether this gig exists, check
      # the method's comments.
      gig, gig_created = Gig.find_or_create_by({
        input_gig: input_gig, 
        venue:     venue,
        comedian:  self
      })
      created[:gigs] += 1 if gig_created

      # And finally, spots.
      spot, spot_created = Spot.find_or_create_by({
        comedian: self,
        gig:      gig
      })
      created[:spots] += 1 if spot_created

    end

    # And we're done! For kewl logging purposes, return our created counts.
    created
  end


  # Only ever called by scrape_all_comedians.rake, as a delayed_job.
  def scrape
    begin
      
      ap "Fetching gig info for #{self.name}..."
      gigs = Comedian.send("gigs_by_#{self.name.parameterize.underscore}")
      ap "Nabbed #{gigs.length} bits of gig info for #{self.name}, creating objects from them..."
      counts = self.create_gigs(gigs)
      ap "Created #{counts[:venues]} venues, #{counts[:gigs]} gigs and #{counts[:spots]} spots for #{self.name}"

    rescue Exception => e
      ap "Oh no! Error scraping #{self.name}:\n"
      ap e.message
      
    end
  end

  # Only ever called by create_comedians_and_mugshots, as a delayed_job.
  def Comedian.find_or_create_with_mugshot(comedian_info)
    c = Comedian.find_or_initialize_by(name: comedian_info[:name])
    c.mugshot = URI.parse(comedian_info[:mugshot_url])
    c.save
  end
end