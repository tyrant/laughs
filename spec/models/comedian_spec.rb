require 'rails_helper'

describe Comedian do 

  describe "validations; " do

    it "is invalid without a name" do
      c = FactoryGirl.build :comedian, name: ''
      expect(c).not_to be_valid
    end

    it "is valid with a name" do
      c = FactoryGirl.build :comedian, name: 'schnozz jr.'
      expect(c).to be_valid
    end

    it "is invalid without a mugshot" do
      c = FactoryGirl.build :comedian, mugshot: nil
      expect(c).not_to be_valid
    end

    it "is valid with a mugshot" do
      c = FactoryGirl.build :comedian
      expect(c).to be_valid
    end
  end

  describe "#as_json; " do

    let!(:c) { FactoryGirl.create :comedian }

    it "returns id" do
      expect(c.as_json[:id]).to eq c.id
    end

    it "returns name" do
      expect(c.as_json[:name]).to eq c.name
    end

    it "returns mugshot_url" do
      expect(c.as_json[:mugshot_url]).to eq c.mugshot.url(:thumb)
    end
  end


  # Wee bit more challenging, this. .create_gigs receives lots of gig data structures
  # in various configurations, and creates gigs and venues from them.
  describe ".create_gigs; " do

    describe "re"
  end
end