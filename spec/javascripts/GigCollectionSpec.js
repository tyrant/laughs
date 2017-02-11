describe("GigCollection", () => {

  describe("#filteredByFormValues", () => {

    let gigs;
    let comedians;

    // Create nine gigs, and different comedian combinations.
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

      gigs = new GigCollection([{
        id: 0,
        time: moment().add(1, 'day').unix(),
        comedian_ids: [0, 1],
      }, {
        id: 1,
        time: moment().add(2, 'days').unix(),
        comedian_ids: [2],
      }, {
        id: 2,
        time: moment().add(5, 'days').unix(),
        comedian_ids: [3],
      }, {
        id: 3,
        time: moment().add(6, 'days').unix(),
        comedian_ids: [2],
      }, {
        id: 4,
        time: moment().add(3, 'days').unix(),
        comedian_ids: [2, 3],
      }, {
        id: 5,
        time: moment().add(4, 'days').unix(),
        comedian_ids: [1, 2],
      }, {
        id: 6,
        time: moment().add(70, 'days').unix(),
        comedian_ids: [0, 3],
      }, {
        id: 7,
        time: moment().add(69, 'days').unix(),
        comedian_ids: [0, 1, 2, 3],
      }, {
        id: 8,
        time: moment().add(68, 'days').unix(),
        comedian_ids: [3],
      }]);
    });

    afterAll(() => {
      gigs.reset();
      comedians.reset();
    });

    it("returns five gigs when comedians=[3]", () => {

      // Start and end are two years apart, to sweep up every gig.
      const filteredGigs = gigs.filteredByFormValues({
        comedians: new ComedianCollection(comedians.at(3)),
        gigFilter: 's',
        start: moment().subtract(1, 'year').unix(),
        end: moment().add(1, 'year').unix(),
      });

      expect(filteredGigs.length).toBe(5);
    });
  });
});