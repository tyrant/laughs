describe("VenueCollection", () => {


  // within() takes four parameters: sw_lat, sw_lng, ne_lat, ne_lng, which
  // trace out a geo-rectangle. It returns all venues within that rectangle.
  describe("#within", () => {

    var venues;

    // Create a nice handy testable 3x3 grid of Venues.
    beforeAll(() => {
      venues = new VenueCollection([
        { latitude: 1, longitude: 1 },
        { latitude: 2, longitude: 1 },
        { latitude: 3, longitude: 1 },
        { latitude: 1, longitude: 2 },
        { latitude: 2, longitude: 2 },
        { latitude: 3, longitude: 2 },
        { latitude: 1, longitude: 3 },
        { latitude: 2, longitude: 3 },
        { latitude: 3, longitude: 3 },
      ]);
    });

    it("returns four venues within bounds (0.5, 0.5), (2.5, 2.5)", () => {

      let bounds = {
        sw_lat: 0.5,
        sw_lng: 0.5,
        ne_lat: 2.5,
        ne_lng: 2.5,
      };

      expect(venues.within(bounds).length).toBe(4);
    });

    it("returns three venues withins bounds (2.5, 0.5), (3.5, 3.5)", () => {

      let bounds = {
        sw_lat: 2.5,
        sw_lng: 0.5,
        ne_lat: 3.5,
        ne_lng: 3.5,
      };

      expect(venues.within(bounds).length).toBe(3);
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
        id: 0,
        name: 'one',
      }, {
        id: 1,
        name: 'two',
      }, {
        id: 2,
        name: 'three',
      }, {
        id: 3,
        name: 'four',
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
        console.log(venues.at(0).gigs().at(0).comedians())
        expect(results.length).toBe(2);
      })

    });

    describe("matching comedians", () => {
      
    });

  });
});