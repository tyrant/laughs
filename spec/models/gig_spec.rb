require 'rails_helper'

describe Gig do

  describe ".find_or_create_by; " do

    let!(:venue) { FactoryGirl.create :venue }
    let!(:comedian) { FactoryGirl.create :comedian }

    describe "Date string has no time component; " do

      let!(:date_without_time) { Faker::Date.between(Date.today, 5.years.from_now).strftime("%-d %B %Y") }

      describe "Another gig by the same comic exists at that exact time; " do

        let!(:existing_gig) { FactoryGirl.create :gig, venue: venue, time: DateTime.parse(date_without_time) }
        let!(:spot) { FactoryGirl.create :spot, gig: existing_gig, comedian: comedian }

        before do
          VCR.use_cassette('Timezone') do
            @gig, @created = Gig.find_or_create_by({
              input_gig: { date: date_without_time }, 
              venue:     venue,
              comedian:  comedian
            })
          end
        end

        it "detects the other gig and returns it; " do
          expect(@gig).to eq existing_gig
        end

        it "returns @created=false" do
          expect(@created).to eq false
        end
      end

      describe "Another gig by the same comic exists within 6 hours; " do

        let!(:existing_gig) { FactoryGirl.create :gig, venue: venue, time: DateTime.parse(date_without_time) + 6.hours }
        let!(:spot) { FactoryGirl.create :spot, gig: existing_gig, comedian: comedian }

        before do
          VCR.use_cassette('Timezone') do
            @gig, @created = Gig.find_or_create_by({
              input_gig: { date: date_without_time }, 
              venue:     venue,
              comedian:  comedian
            })
          end
        end

        it "detects the other gig and returns it; " do
          expect(@gig).to eq existing_gig
        end

        it "returns @created=false" do
          expect(@created).to eq false
        end
      end

      describe "Another gig by a different comic exists within 6 hours; " do

        let!(:other_comic) { FactoryGirl.create :comedian }
        let!(:other_gig) { FactoryGirl.create :gig, venue: venue }
        let!(:other_spot) { FactoryGirl.create :spot, comedian: other_comic, gig: other_gig }

        before do
          @existing_gig_count = Gig.count
          VCR.use_cassette('Timezone') do
            @gig, @created = Gig.find_or_create_by({
              input_gig: { date: date_without_time }, 
              venue:     venue,
              comedian:  other_comic
            })
          end
        end

        it "ignores that other comic's gig and creates a new one; " do
          expect(@gig).not_to eq other_gig
        end

        it "returns @created=true" do
          expect(@created).to eq true
        end

        it "bumps up Gig.count" do
          expect(Gig.count).to eq @existing_gig_count + 1
        end
      end
    end

    describe "Date string has a time component; " do

      let!(:date_with_time) { "#{Faker::Date.between(Date.today, 5.years.from_now).strftime("%-d %B %Y")} 7:30pm" }

      describe "Another gig by the same comic exists at that exact time; " do

        let!(:existing_gig) { FactoryGirl.create :gig, venue: venue, time: DateTime.parse(date_with_time) }
        let!(:spot) { FactoryGirl.create :spot, gig: existing_gig, comedian: comedian }

        before do
          VCR.use_cassette('Timezone') do
            @gig, @created = Gig.find_or_create_by({
              input_gig: { date: date_with_time }, 
              venue:     venue,
              comedian:  comedian
            })
          end
        end

        it "detects that other gig and returns it; " do
          expect(@gig).to eq existing_gig
        end

        it "returns @created=false" do
          expect(@created).to eq false
        end
      end

      describe "Another gig by the same comic exists within 6 hours; " do

        let!(:existing_gig) { FactoryGirl.create :gig, venue: venue, time: DateTime.parse(date_with_time) + 6.hours }
        let!(:spot) { FactoryGirl.create :spot, gig: existing_gig, comedian: comedian }

        before do
          @existing_gig_count = Gig.count
          VCR.use_cassette('Timezone') do
            @gig, @created = Gig.find_or_create_by({
              input_gig: { date: date_with_time }, 
              venue:     venue,
              comedian:  comedian
            })
          end
        end

        it "ignores that other gig and creates a new one" do
          expect(@gig).not_to eq existing_gig
        end

        it "returns @created=true" do
          expect(@created).to eq true
        end

        it "bumps up Gig.count" do
          expect(Gig.count).to eq @existing_gig_count + 1
        end
      end

      describe "Another gig by a different comic exists within 6 hours; " do

        let!(:other_comic) { FactoryGirl.create :comedian }
        let!(:other_gig) { FactoryGirl.create :gig, venue: venue }
        let!(:other_spot) { FactoryGirl.create :spot, comedian: other_comic, gig: other_gig }

        before do
          @existing_gig_count = Gig.count
          VCR.use_cassette('Timezone') do
            @gig, @created = Gig.find_or_create_by({
              input_gig: { date: date_with_time }, 
              venue:     venue,
              comedian:  other_comic
            })
          end
        end

        it "ignores that other comic's gig and creates a new one" do
          expect(@gig).not_to eq other_gig
        end

        it "returns @created=true" do
          expect(@created).to eq true
        end

        it "bumps up Gig.count" do
          expect(Gig.count).to eq @existing_gig_count + 1
        end
      end
    end

    describe "timezones; " do
    end

  end

  describe "#as_json; " do

    let!(:gig) { FactoryGirl.create :gig, venue: FactoryGirl.create(:venue) }
    let!(:c1) { FactoryGirl.create :comedian }
    let!(:c2) { FactoryGirl.create :comedian }
    let!(:s1) { FactoryGirl.create :spot, gig: gig, comedian: c1 }
    let!(:s2) { FactoryGirl.create :spot, gig: gig, comedian: c2 }

    it "returns the same ID" do
      expect(gig.id).to eq gig.as_json[:id]
    end

    it "returns the same time" do
      expect(gig.time.to_i).to eq gig.as_json[:time]
    end

    it "returns the same venue booking url" do
      expect(gig.venue_booking_url).to eq gig.as_json[:venue_booking_url]
    end

    it "returns the same ticketmaster booking url" do
      expect(gig.ticketmaster_booking_url).to eq gig.as_json[:ticketmaster_booking_url]
    end

    it "returns the same spots" do
      expect(gig.spots.map(&:id)).to eq gig.as_json[:spots].map{|s| s[:id] }
    end
  end
end