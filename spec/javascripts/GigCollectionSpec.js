describe("GigCollection", () => {

  let gigs;
  let comedians;
  let spots;

  // Create nine gigs, and different comedian combinations.
  beforeAll(() => {

    comedians = new ComedianCollection([
      { id: 1, name: 'one', }, 
      { id: 2, name: 'two', }, 
      { id: 3, name: 'three', }, 
      { id: 4, name: 'four', },
    ]);

    gigs = new GigCollection([
      { id: 1, time: moment().add(1, 'day').unix(), },
      { id: 2, time: moment().add(2, 'days').unix(), },
      { id: 3, time: moment().add(5, 'days').unix(), }, 
      { id: 4, time: moment().add(6, 'days').unix(), },
      { id: 5, time: moment().add(3, 'days').unix(), },
      { id: 6, time: moment().add(4, 'days').unix(), },
      { id: 7, time: moment().add(70, 'days').unix(), },
      { id: 8, time: moment().add(69, 'days').unix(), },
      { id: 9, time: moment().add(68, 'days').unix(), },
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
    gigs.reset();
    comedians.reset();
    spots.reset();
  });

  describe("#filteredByFormValues", () => {

    it("returns 5 gigs when comedians=[3]", () => {

      // Start and end are two years apart, to sweep up every gig.
      const filteredGigs = gigs.filteredByFormValues({
        comedians:  new ComedianCollection(comedians.at(3)),
        gigFilter: 's',
        start:      moment().subtract(1, 'year').unix(),
        end:        moment().add(1, 'year').unix(),
      });

      expect(filteredGigs.length).toEqual(5);
    });

    it("returns 7 gigs when comedians=[0, 2]", () => {

      const filteredGigs = gigs.filteredByFormValues({
        comedians:  new ComedianCollection([comedians.at(0), comedians.at(2)]),
        gigFilter: 's',
        start:      moment().subtract(1, 'year').unix(),
        end:        moment().add(1, 'year').unix(),
      });

      expect(filteredGigs.length).toEqual(7);
    });
  });

  describe("#sortedByTime", () => {

    it("orders all nine gigs by time, ascending", () => {
      expect(gigs.sortedByTime().pluck('id')).toEqual([1, 2, 5, 6, 3, 4, 9, 8, 7]);
    });
  });
});