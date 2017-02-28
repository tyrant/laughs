FactoryGirl.define do

  factory :comedian do
    name { Faker::Name.name }
    mugshot { File.new("#{Rails.root}/spec/handsomebastard.jpg") }
  end

  factory :spot do
  end

  factory :gig do
    time { Faker::Time.between(DateTime.now, DateTime.now + 2.years) }
    sequence(:venue_booking_url) {|n| "theatre.co.uk?gig=#{n}" }
    sequence(:ticketmaster_booking_url) {|n| "ticketmaster.co.uk?gig=#{n}" }
  end

  factory :venue do
    name { Faker::Commerce.product_name }
    description { Faker::TwinPeaks.quote }

    # Virtual attributes and not database columns!
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    # These are real and consistent.
    readable_address "Crescent Rd, Royal Tunbridge Wells TN1 2LU, United Kingdom"
    google_place_id 'ChIJTbF2KTJE30cRzF7_P7QNC1k'

    phone { Faker::PhoneNumber.phone_number }
    deets 'Down by the docks'

    after :build do |venue|
      venue.set_location(latitude: venue.latitude, longitude: venue.longitude)
    end

  end

end
