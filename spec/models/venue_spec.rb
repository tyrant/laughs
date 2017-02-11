require 'rails_helper'

describe Venue do

  describe "validations; " do

    it "isn't valid with latitude < -90" do
      c = FactoryGirl.build :venue, latitude: -100
      expect(c).not_to be_valid
    end

    it "isn't valid with latitude > 90" do
      c = FactoryGirl.build :venue, latitude: 100
      expect(c).not_to be_valid
    end

    it "is valid with latitude nil" do
      c = FactoryGirl.build :venue, latitude: nil
      expect(c).to be_valid
    end

    it "is valid with latitude >-90 and <90" do
      c = FactoryGirl.build :venue, latitude: 30
      expect(c).to be_valid
    end

    it "isn't valid with longitude < -180" do
      c = FactoryGirl.build :venue, longitude: -200
      expect(c).not_to be_valid
    end

    it "isn't valid with longitude > 180" do
      c = FactoryGirl.build :venue, longitude: 200
      expect(c).not_to be_valid
    end

    it "is valid with longitude nil" do
      c = FactoryGirl.build :venue, longitude: nil
      expect(c).to be_valid
    end

    it "is valid with longitude >-180 and <180" do
      c = FactoryGirl.build :venue, longitude: 30
      expect(c).to be_valid
    end
  end

  describe "scopes; " do

    describe "lat/lng; " do

      # Create five! One with lat/lng set properly, two with both nil, and two with one nil.
      let!(:v1) { FactoryGirl.create :venue, latitude: 3, longitude: 5 }
      let!(:v2) { FactoryGirl.create :venue, latitude: 23, longitude: nil }
      let!(:v3) { FactoryGirl.create :venue, latitude: nil, longitude: 3 }
      let!(:v4) { FactoryGirl.create :venue, latitude: nil, longitude: nil }
      let!(:v5) { FactoryGirl.create :venue, latitude: nil, longitude: nil }

      it "returns only v1 with .locatable" do
        expect(Venue.locatable).to eq [v1]
      end

      it "returns v4 and v5 with terra_incognita" do
        expect(Venue.terra_incognita).to eq [v4, v5]
      end
    end

    describe "filter; " do

      let!(:c1) { FactoryGirl.create :comedian }
      let!(:c2) { FactoryGirl.create :comedian }
      let!(:v1) { FactoryGirl.create :venue, latitude: 20, longitude: 20 }
      let!(:v2) { FactoryGirl.create :venue, latitude: 20, longitude: 170 }
      let!(:v3) { FactoryGirl.create :venue, latitude: -20, longitude: -170 }
      let!(:g1) { FactoryGirl.create :gig, time: DateTime.now + 2.days, venue: v1 }
      let!(:g2) { FactoryGirl.create :gig, time: DateTime.now + 3.days, venue: v1 }
      let!(:g3) { FactoryGirl.create :gig, time: DateTime.now + 4.days, venue: v2 }
      let!(:g4) { FactoryGirl.create :gig, time: DateTime.now + 5.days, venue: v2 }
      let!(:g5) { FactoryGirl.create :gig, time: DateTime.now + 6.days, venue: v3 }
      let!(:s1) { FactoryGirl.create :spot, comedian: c1, gig: g1 }
      let!(:s2) { FactoryGirl.create :spot, comedian: c1, gig: g2 }
      let!(:s3) { FactoryGirl.create :spot, comedian: c1, gig: g3 }
      let!(:s4) { FactoryGirl.create :spot, comedian: c2, gig: g3 }
      let!(:s5) { FactoryGirl.create :spot, comedian: c2, gig: g4 }
      let!(:s6) { FactoryGirl.create :spot, comedian: c2, gig: g5 }

      # Venue.filter has five parameters
      # An array of comedians IDs: include venues with at least one comedian amongst this lot.
      # A start_date timestamp (seconds): include venues with at least one gig after this time.
      # An end timestamp (seconds): include venues with at least one gig before this time.
      # A list of venue IDs to include regardless of the above filters;
      # A list of venue IDs to exclude regardless of the above filters.

      it "returns all venues when all params are absent" do
        expect(Venue.filter).to eq [v1, v2, v3]
      end

      describe "comedian IDs; " do

        it "returns venues 1 and 2 when supplied with comedian 1" do
          expect(Venue.filter(comedians: [c1.id])).to eq [v1, v2]
        end

        it "returns venues 2 and 3 when supplied with comedian 2" do
          expect(Venue.filter(comedians: [c2.id])).to eq [v2, v3]
        end
      end

      describe "start timestamp; " do

        # All examples: end_date is 10 days ahead, ahead of all gigs here.

        it "returns venue 3 when start_date is 5.5 days ahead" do
          venues = Venue.filter start_date: (Time.now + 5.5.days).to_i, end_date: (Time.now + 10.days).to_i
          expect(venues).to eq [v3]
        end 

        it "returns venues 2 and 3 when start_date is 3.5 days ahead" do
          venues = Venue.filter start_date: (Time.now + 3.5.days).to_i, end_date: (Time.now + 10.days).to_i
          expect(venues).to eq [v2, v3]
        end

        it "returns all three venues when start_date is 2 days past" do
          venues = Venue.filter start_date: (Time.now - 2.days).to_i, end_date: (Time.now + 10.days).to_i
          expect(venues).to eq [v1, v2, v3]
        end
      end

      describe "end timestamp; " do

        # All examples: start_date is 10 days ago, behind all gigs here.

        it "returns venue 1 when end_date is 2.5 days ahead" do
          venues = Venue.filter end_date: (Time.now + 2.5.days).to_i, start_date: (Time.now - 10.days).to_i
          expect(venues).to eq [v1]
        end 

        it "returns venues 1 and 2 when end_date is 4.5 days ahead" do
          venues = Venue.filter end_date: (Time.now + 4.5.days).to_i, start_date: (Time.now - 10.days).to_i
          expect(venues).to eq [v1, v2]
        end

        it "returns all three venues when end_date is 7 days ahead" do
          venues = Venue.filter end_date: (Time.now + 7.days).to_i, start_date: (Time.now - 10.days).to_i
          expect(venues).to eq [v1, v2, v3]
        end
      end

      describe "with; " do

        it "doesn't return v3 normally" do
          venues = Venue.filter comedians: [c1.id]
          expect(venues).not_to include v3
        end

        it "returns v3 when the filter otherwise excludes v3" do
          venues = Venue.filter comedians: [c1.id], with: [v3.id]
          expect(venues).to include v3
        end
      end

      describe "without; " do

        it "returns v3 normally" do
          venues = Venue.filter comedians: [c2.id]
          expect(venues).to include v3
        end

        it "doesn't return v3 when the filter otherwise would" do
          venues = Venue.filter comedians: [c2.id], without: [v3.id]
          expect(venues).not_to include v3
        end
      end

      describe "lat/lng bounds; " do

        # Rectangle doesn't straddle the date line
        it "returns v1, v2 with sw_lat=10, sw_lng=10, ne_lat=30, ne_lng=175" do
          venues = Venue.filter sw_lat: 10, sw_lng: 10, new_lat: 30, ne_lng: 175
          expect(venues).to eq [v1, v2]
        end

        # Rectangle straddles date line
        it "returns v2, v3 with sw_lat=-30, sw_lng=165, ne_lat=30, ne_lng=-165" do
          venues = Venue.filter sw_lat: -30, sw_lng: 165, ne_lat: 30, ne_lng: -165
          expect(venues).to eq [v2, v3]
        end

        # No straddling
        it "returns v1, v3 with sw_lat=-30, sw_lng=-175, ne_lat=25, ne_lng=25" do
          venues = Venue.filter sw_lat: -30, sw_lng: -175, ne_lat: 25, ne_lng: 25
          expect(venues).to eq [v1, v3]
        end

        # Straddling
        it "returns v1, v3 with sw_lat=-30, sw_lng=175, ne_lat=25, ne_lng=25" do
          venues = Venue.filter sw_lat: -30, sw_lng: 175, ne_lat: 25, ne_lng: 25
          expect(venues).to eq [v1, v3]
        end
      end
    end

  end

  # Given 'venue_deets', this first tries to find a venue with those same deets.
  # If there's nothing, it hits the Google Place API with those same deets,
  # searches venues again with the returned Google Place ID, and if there's 
  # nothing again, creates a new venue with deets and place properties.
  describe ".find_or_create_by; " do

    let!(:google_place_id) { "ChIJTbF2KTJE30cRzF7_P7QNC1k" }
    let!(:venue_with_real_deets_and_id) { FactoryGirl.create :venue, deets: "Tunbridge Wells - Assembly Halls Theatre", google_place_id: google_place_id }

    describe "matching exact deets; " do

      before do
        @venue, @created = Venue.find_or_create_by venue_deets: "Tunbridge Wells - Assembly Halls Theatre"
      end

      it "returns our venue with exact deets search" do
        expect(@venue).to eq venue_with_real_deets_and_id
      end

      it "returns created=false" do
        expect(@created).to be false
      end
    end

    describe "matching with inexact deets but exact place ID; " do

      before do
        # We shall intercept any attempted calls to Google's Place API.
        VCR.use_cassette('GP') do
          @venue, @created = Venue.find_or_create_by venue_deets: "Tunbridge Wells, Assembly Halls Theatre"
        end
      end

      it "still returns our venue with slightly different deets" do
        expect(@venue).to eq venue_with_real_deets_and_id
      end

      it "returns created=false" do
        expect(@created).to be false
      end

      it "sets the same place ID as on our example" do
        expect(@venue.google_place_id).to eq google_place_id
      end
    end

    describe 'creating a new venue when deets are unique and return a result from the place API; ' do

      before do
        @venue, @created = Venue.find_or_create_by venue_deets: "Guildhall Southampton"
      end

      it "creates a new venue" do
        expect(@created).to be true
      end

      it "sets another place ID, different from our example" do
        expect(@venue.google_place_id).not_to eq google_place_id
      end
    end

    describe 'creating a new venue when deets are unique and return nothing from Google; ' do

      before do
        @venue, @created = Venue.find_or_create_by venue_deets: "suck on this"
      end

      it "creates a new venue" do
        expect(@created).to be true
      end

      it "doesn't set a latitude" do
        expect(@venue.latitude).to be nil
      end

      it "doesn't set a longitude" do
        expect(@venue.longitude).to be nil
      end

      it "doesn't set a place ID" do
        expect(@venue.google_place_id).to be nil
      end

    end

    it "creates a new venue with the inputted phone number" do
      @venue, @created = Venue.find_or_create_by venue_deets: "Guildhall Southampton", phone: "02380 632 601"
      expect(@venue.phone).to eq "02380 632 601"
    end
  end


  describe ".placeify; " do

    let!(:v1) { FactoryGirl.create :venue, deets: "Tunbridge Wells - Assembly Halls Theatre", latitude: 51.1323489, longitude: 0.2644018, google_place_id: "ChIJTbF2KTJE30cRzF7_P7QNC1k" }
    let!(:v2) { FactoryGirl.create :venue, deets: "Guildhall Southampton", latitude: nil, longitude: nil, google_place_id: nil }

    it "returns only v2 from Venue.terra_incognita" do
      expect(Venue.terra_incognita).to eq [v2]
    end

    describe "placeifying; " do

      before do
        # VCR.use_cassette('GP', record: :new_episodes) do
        #   Venue.placeify
        # end
      end

      it "now returns 0 from Venue.terra_incognita.count" do
        VCR.use_cassette('GP', record: :once) do
          Venue.placeify
          expect(Venue.terra_incognita.count).to eq 0
        end
        
      end

      it "has returned the right, real google place ID" do
        VCR.use_cassette('GP', record: :once) do
          Venue.placeify
          expect(v2.google_place_id).to eq "ChIJb9gysLF2dEgR81lqnq80s_Q"
        end
        
      end

      it "has returned the right, real latitude" do
        expect(v2.latitude).to eq 50.9079988
      end

      it "has returned the right, real longitude" do
        expect(v2.longitude).to eq -1.4061987
      end
    end
  end


  describe "#as_json; " do

    let!(:v) { FactoryGirl.create :venue }
    let!(:g1) { FactoryGirl.create :gig, venue: v }
    let!(:g2) { FactoryGirl.create :gig, venue: v }

    it "shows the venue's ID" do
      expect(v.id).to eq v.as_json[:id]
    end

    it "shows the venue's name" do
      expect(v.name).to eq v.as_json[:name]
    end

    it "shows the venue's latitude" do
      expect(v.latitude).to eq v.as_json[:latitude]
    end

    it "shows the venue's longitude" do
      expect(v.longitude).to eq v.as_json[:longitude]
    end

    it "shows the venue's readable address" do
      expect(v.readable_address).to eq v.as_json[:readable_address]
    end

    it "shows the venue's phone number" do
      expect(v.phone).to eq v.as_json[:phone]
    end

    it "shows the two gigs" do
      expect(v.gigs.map(&:id)).to eq [v.gigs[0].id, v.gigs[1].id]
    end
  end
end