require 'rails_helper'

describe Gig do

  describe ".find_or_create_by; " do

    let!(:v) { FactoryGirl.create :venue }
    let!(:date) { "4 January 2018" }
    let!(:existing_gig) { FactoryGirl.create :gig, venue: v, time: DateTime.parse(date) }

    describe "Gig object already exists; " do

      before do
        @gig, @created = Gig.find_or_create_by({ date: date }, v)
      end

      it "returns the existing gig" do
        expect(@gig).to eq existing_gig
      end

      it "returns @created=false" do
        expect(@created).to eq false
      end
    end

    describe "Gig object doesn't exist; " do

      let!(:other_date) { "5 January 2018" }

      before do 
        @current_gig_count = Gig.count
        @gig, @created = Gig.find_or_create_by({ date: other_date }, v)
      end

      it "returns a new gig" do
        expect(@gig).not_to eq existing_gig
      end

      it "bumps up the Gigs count" do
        expect(Gig.count).to eq @current_gig_count + 1
      end

      it "returns @created=true" do
        expect(@created).to eq true
      end
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