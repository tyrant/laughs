describe("VenueCollection", () => {

  // within() takes four parameters: sw_lat, sw_lng, ne_lat, ne_lng, which
  // trace out a geo-rectangle. It returns all venues within that rectangle.
  describe("#within", () => {

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

      expect(venues.within(bounds).length).toBe(4);
    });

    it("returns three venues within IDL-straddling bounds (5, 160), (15, -170)", () => {

      let bounds = {
        sw_lat: 5,
        sw_lng: 160,
        ne_lat: 15,
        ne_lng: -170,
      };

      expect(venues.within(bounds).length).toBe(3);
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

    // Create three venues, each with three gigs, and different comedian combinations.
    beforeAll(() => {

      comedians = new ComedianCollection([{
        id: 0, name: 'one',
      }, {
        id: 1, name: 'two',
      }, {
        id: 2, name: 'three',
      }, {
        id: 3, name: 'four',
      }]);

      venues = new VenueCollection([{
        id: 0,
        name: '1,2,3',
        gigs: [{
            id: 0,
            time: moment().add(1, 'day').unix(),
            venue_id: 0,
            comedian_ids: [0, 1],
          }, {
            id: 1,
            time: moment().add(2, 'days').unix(),
            venue_id: 0,
            comedian_ids: [2],
          }, {
            id: 2,
            time: moment().add(3, 'days').unix(),
            venue_id: 0,
            comedian_ids: [3],
          }],
      }, {
        id: 1,
        name: '4,5,6',
        gigs: [{
            id: 3,
            time: moment().add(4, 'days').unix(),
            venue_id: 1,
            comedian_ids: [2],
          }, {
            id: 4,
            time: moment().add(5, 'days').unix(),
            venue_id: 1,
            comedian_ids: [2, 3],
          }, {
            id: 5,
            time: moment().add(6, 'days').unix(),
            venue_id: 1,
            comedian_ids: [1, 2],
          }],
      }, {
        id: 2,
        name: '7,8,9',
        gigs: [{
            id: 6,
            time: moment().add(7, 'days').unix(),
            venue_id: 2,
            comedian_ids: [0, 3],
          }, {
            id: 7,
            time: moment().add(8, 'days').unix(),
            venue_id: 2,
            comedian_ids: [0, 1, 2, 3],
          }, {
            id: 8,
            time: moment().add(9, 'days').unix(),
            venue_id: 2,
            comedian_ids: [3],
          }],
      }]);
    });

    afterAll(() => {
      venues.reset();
      comedians.reset();
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