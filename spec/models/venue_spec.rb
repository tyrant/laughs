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
      let!(:v1) { FactoryGirl.create :venue }
      let!(:v2) { FactoryGirl.create :venue }
      let!(:v3) { FactoryGirl.create :venue }
      let!(:g1) { FactoryGirl.create :gig, comedians: [c1], time: DateTime.now + 2.days, venue: v1 }
      let!(:g2) { FactoryGirl.create :gig, comedians: [c1], time: DateTime.now + 3.days, venue: v1 }
      let!(:g3) { FactoryGirl.create :gig, comedians: [c1, c2], time: DateTime.now + 4.days, venue: v2 }
      let!(:g4) { FactoryGirl.create :gig, comedians: [c2], time: DateTime.now + 5.days, venue: v2 }
      let!(:g5) { FactoryGirl.create :gig, comedians: [c2], time: DateTime.now + 6.days, venue: v3 }


      # Venue.filter has five parameters:
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
    end

  end

  
  describe ".find_or_create_by_gig_deets" do

  end
end