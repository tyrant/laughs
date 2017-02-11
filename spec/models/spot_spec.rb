require 'rails_helper'

describe Spot do

  let!(:venue) { FactoryGirl.create :venue }
  let!(:gig) { FactoryGirl.create :gig, venue: venue }
  let!(:comedian) { FactoryGirl.create :comedian }
  let!(:spot) { FactoryGirl.create :spot, gig: gig, comedian: comedian }

  describe "associations; " do

    it "saves the right gig" do
      expect(spot.gig).to eq gig
    end

    it "saves the right comedian" do
      expect(spot.comedian).to eq comedian
    end
  end

  describe "validations; " do

    let!(:s) { FactoryGirl.build_stubbed :spot, gig: nil, comedian: nil }

    it "isn't valid" do
      expect(s).not_to be_valid
    end

    it "says the gig must exist" do
      expect(s.errors.messages[:gig]).to eq 'Must exist'
    end

    it "says the comedian must exist" do
      expect(s.errors.messages[:comedian]).to eq 'Must exist'
    end
  end

  describe ".find_or_create_by; " do

    describe "Both comedian and gig already exist on the spot; " do

      before do
        @spot, @created = Spot.find_or_create_by(comedian, gig)
      end

      it "returns the current spot" do
        expect(@spot).to eq spot
      end

      it "returns @created=false" do
        expect(@created).to eq false
      end

      it "sets @spot.comedian=comedian" do
        expect(@spot.comedian).to eq comedian
      end

      it "sets @spot.gig=gig" do
        expect(@spot.gig).to eq gig
      end
    end

    describe "Comedian exists on spot, gig doesn't; " do

      let!(:another_gig) { FactoryGirl.create :gig, venue: FactoryGirl.create(:venue) }

      before do
        @spot_count = Spot.count
        @spot, @created = Spot.find_or_create_by(comedian, another_gig)
      end

      it "creates a new spot" do
        expect(@spot).not_to eq spot
      end

      it "bumps up Spot.count" do
        expect(Spot.count).to eq @spot_count + 1
      end

      it "returns @created=true" do
        expect(@created).to eq true
      end


      it "sets @spot.comedian=comedian" do
        expect(@spot.comedian).to eq comedian
      end

      it "sets @spot.gig=another_gig" do
        expect(@spot.gig).to eq another_gig
      end
    end

    describe "Gig exists on spot, comedian doesn't; " do

      let!(:another_comedian) { FactoryGirl.create :comedian }

      before do
        @spot_count = Spot.count
        @spot, @created = Spot.find_or_create_by(another_comedian, gig)
      end

      it "creates a new spot" do
        expect(@spot).not_to eq spot
      end

      it "bumps up Spot.count" do
        expect(Spot.count).to eq @spot_count + 1
      end

      it "returns @created=true" do
        expect(@created).to eq true
      end

      it "sets @spot.comedian=another_comedian" do
        expect(@spot.comedian).to eq another_comedian
      end

      it "sets @spot.gig=gig" do
        expect(@spot.gig).to eq gig
      end
    end

    describe "Neither comedian nor gig exist on spot; " do

      let!(:another_gig) { FactoryGirl.create :gig, venue: FactoryGirl.create(:venue) }
      let!(:another_comedian) { FactoryGirl.create :comedian }

      before do
        @spot_count = Spot.count
        @spot, @created = Spot.find_or_create_by(another_comedian, another_gig)
      end

      it "creates a new spot" do
        expect(@spot).not_to eq spot
      end

      it "bumps up Spot.count" do
        expect(Spot.count).to eq @spot_count + 1
      end

      it "returns @created=true" do
        expect(@created).to eq true
      end

      it "sets @spot.comedian=another_comedian" do
        expect(@spot.comedian).to eq another_comedian
      end

      it "sets @spot.gig=another_gig" do
        expect(@spot.gig).to eq another_gig
      end
    end
  end

  describe "#as_json; " do

    it "returns the right full gig when gig=full" do
      expect(spot.as_json(gig: 'full')[:gig]).to eq gig.as_json
    end

    it "returns the right gig ID when gig=id" do
      expect(spot.as_json(gig: 'id')[:gig][:id]).to eq gig.id
    end

    it "returns the right full comedian when comedian=full" do
      expect(spot.as_json(comedian: 'full')[:comedian]).to eq comedian.as_json
    end

    it "returns the right comedian ID when comedian=id" do
      expect(spot.as_json(comedian: 'id')[:comedian][:id]).to eq comedian.id
    end
  end
end