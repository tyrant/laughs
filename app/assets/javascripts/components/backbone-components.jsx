window.Comedian = Backbone.Model.extend({

});

window.Gig = Backbone.Model.extend({

  initialize: function(params) {
    this.set({
      comedians: new ComedianCollection(params.comedians),
      time:      moment(params.time),
    });
  },

  toJSON: function() {
    return {
      id: this.id,
    };
  },

  // Return either preferentially the Ticketmaster booking URL,
  // or if that's not there, the venue booking URL.
  bookingUrl: function() {
    return this.get('ticketmaster_booking_url')
      ? this.get('ticketmaster_booking_url')
      : this.get('venue_booking_url');
  }

});

window.Venue = Backbone.Model.extend({

  initialize: function(params) {
    this.set({ 
      gigs: new GigCollection(params.gigs) 
    });
  }

});

window.ComedianCollection = Backbone.Collection.extend({
  model: Comedian
});

window.GigCollection = Backbone.Collection.extend({

  model: Gig,

  sortedByTime: () => {
    const sortedGigs = this.sortBy((gig) => {
      return gig.get('time').unix();
    });

    return new GigCollection(sortedGigs);
  }
});


window.VenueCollection = Backbone.Collection.extend({

  model: Venue,


  // Receive a comedian list, start date and end date.
  // Return a filtered list of allVenues, where each venue has at least one gig
  // between p.start and p.end, and that gig's comedian list must have at least
  // one comedian within p.comedianIds.
  matchVenuesAndGigs: function(p) {

    const comedianIds = p.comedians.pluck('id');

    const matchingVenues = this.filter((venue) => {

      const gigs = venue.get('gigs').filter((gig) => {
        const timeMatch = p.start.isBefore(gig.get('time')) && p.end.isAfter(gig.get('time'));
        const gigComedianIds = gig.get('comedians').pluck('id');
        const comediansMatch = _.intersection(comedianIds, gigComedianIds).length > 0;

        return timeMatch && comediansMatch;
      });


      // Problem! I'm not that sure how to deep-clone a venue's gigs list,
      // so I'm just making a copy with a different name, to avoid overwriting
      // their actual gigs.
      venue.set({ filteredGigs: new GigCollection(gigs) });

      return gigs.length >= 1;
    });

    return new VenueCollection(matchingVenues);
  }
});