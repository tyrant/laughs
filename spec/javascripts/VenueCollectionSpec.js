describe("VenueCollection", () => {

  // within() takes four parameters: sw_lat, sw_lng, ne_lat, ne_lng, which
  // trace out a geo-rectangle. It returns all venues within that rectangle.
  describe("#inside", () => {

    let venues;

    // Create a nice handy testable 3x3 grid of Venues, straddling
    // the international date line.
    beforeAll(() => {
      venues = new VenueCollection([
        { latitude: 10, longitude: 165 },
        { latitude: 20, longitude: 165 },
        { latitude: 30, longitude: 165 },
        { latitude: 10, longitude: 175 },
        { latitude: 20, longitude: 175 },
        { latitude: 30, longitude: 175 },
        { latitude: 10, longitude: -175 },
        { latitude: 20, longitude: -175 },
        { latitude: 30, longitude: -175 },
      ]);
    });

    it("returns four venues within bounds (5, 160), (25, 180)", () => {

      let bounds = {
        sw_lat: 5,
        sw_lng: 160,
        ne_lat: 25,
        ne_lng: 180,
      };

      expect(venues.inside(bounds).length).toBe(4);
    });

    it("returns three venues within IDL-straddling bounds (5, 160), (15, -170)", () => {

      let bounds = {
        sw_lat: 5,
        sw_lng: 160,
        ne_lat: 15,
        ne_lng: -170,
      };

      expect(venues.inside(bounds).length).toBe(3);
    });

    afterAll(() => {
      venues.reset();
    });
  });


  // matchVenuesAndGigs() takes four parameters: start timestamp, end timestamp,
  // a ComedianCollection, and gigFilter ('a' or 's'), a flag to indicate
  // whether each venue's gig list should be limited to just the search terms or not.
  // It returns all venues with at least one venue matching the filters.
  describe("#matchVenuesAndGigs", () => {

    var venues;
    var comedians;
    var gigs;
    var spots;

    // Create three venues, each with three gigs, and different comedian combinations.
    beforeAll(() => {

      comedians = new ComedianCollection([
        { id: 1, name: 'one', }, 
        { id: 2, name: 'two', },
        { id: 3, name: 'three', },
        { id: 4, name: 'four', }
      ]);

      venues = new VenueCollection([
        { id: 1, name: '1,2,3', },
        { id: 2, name: '4,5,6', }, 
        { id: 3, name: '7,8,9', },
      ]);

      gigs = new GigCollection([
        { id: 1, time: moment().add(1, 'day').unix(), venue_id: 1, },
        { id: 2, time: moment().add(2, 'days').unix(), venue_id: 1, }, 
        { id: 3, time: moment().add(3, 'days').unix(), venue_id: 1, },
        { id: 4, time: moment().add(4, 'days').unix(), venue_id: 2, },
        { id: 5, time: moment().add(5, 'days').unix(), venue_id: 2, },
        { id: 6, time: moment().add(6, 'days').unix(), venue_id: 2, },
        { id: 7, time: moment().add(7, 'days').unix(), venue_id: 3, }, 
        { id: 8, time: moment().add(8, 'days').unix(), venue_id: 3, },
        { id: 9, time: moment().add(9, 'days').unix(), venue_id: 3, },
      ]);

      spots = new SpotCollection([
        { id: 1, gig_id: 1, comedian_id: 1, },
        { id: 2, gig_id: 1, comedian_id: 2, },
        { id: 3, gig_id: 2, comedian_id: 3, },
        { id: 4, gig_id: 3, comedian_id: 4, },
        { id: 5, gig_id: 4, comedian_id: 3, },
        { id: 6, gig_id: 5, comedian_id: 3, },
        { id: 7, gig_id: 5, comedian_id: 4, },
        { id: 8, gig_id: 6, comedian_id: 2, },
        { id: 9, gig_id: 6, comedian_id: 3, },
        { id: 10, gig_id: 7, comedian_id: 1, },
        { id: 11, gig_id: 7, comedian_id: 4, },
        { id: 12, gig_id: 8, comedian_id: 1, },
        { id: 13, gig_id: 8, comedian_id: 2, },
        { id: 14, gig_id: 8, comedian_id: 3, },
        { id: 15, gig_id: 8, comedian_id: 4, },
        { id: 16, gig_id: 9, comedian_id: 4, },
      ]);
    });


    afterAll(() => {
      venues.reset();
      comedians.reset();
      gigs.reset();
      spots.reset();
    });

    describe("matching start and end times", () => {

      it("returns two venues when start==2.5 days and end==4.5 days", () => {

        // I tried doing add(2.5, 'days'), but it rounds up! Doesn't like floats.
        // As per the final para in http://momentjs.com/docs/#/manipulating/add/. Rrr.
        let results = venues.matchVenuesAndGigs({
          start:     moment().add(60, 'hours').unix(), // 60 hours == 2.5 days
          end:       moment().add(108, 'hours').unix(), // 108 hours == 4.5 days
          gigFilter: 's',
        });

        expect(results.length).toBe(2);
      });

      it("returns two venues when start==5.5days and end==7.5 days", () => {

        let results = venues.matchVenuesAndGigs({
          start:     moment().add(132, 'hours').unix(), 
          end:       moment().add(180, 'hours').unix(),
          gigFilter: 's',
        });

        expect(results.length).toBe(2);
      })

    });

    describe("matching comedians", () => {
      
    });

  });
});