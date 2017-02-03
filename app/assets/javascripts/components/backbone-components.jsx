window.Comedian = Backbone.Model.extend({

});

window.Gig = Backbone.Model.extend({

  initialize: function(params) {
    this.set({
      comedians: new ComedianCollection(params.comedians),
      time:      params.time,
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


  sortedByTime: function() {
    const sortedGigs = this.sortBy('time');
    return new GigCollection(sortedGigs);
  },


  // Receive: comedian IDs, start/end dates, and gig filter ('s'/'a').
  filteredByFormValues: function(p) {

    if (p.gigFilter == 's') {

      const comedianIds = p.comedians.pluck('id');

      const gigs = this.filter((gig) => {
        const timeMatch = p.start < gig.get('time') && p.end > gig.get('time');
        const gigComedianIds = gig.get('comedians').pluck('id');
        const comediansMatch = _.intersection(comedianIds, gigComedianIds).length > 0;

        return timeMatch && comediansMatch;
      });

      return new GigCollection(gigs); 

    } else if (p.gigFilter == 'a') {
      return this;
    }
  },
});


window.VenueCollection = Backbone.Collection.extend({

  model: Venue,


  // Receive a comedian list, start date, end date, and gig filter.
  // Return a filtered list of allVenues, where each venue has at least one gig
  // between p.start and p.end, and that gig's comedian list must have at least
  // one comedian within p.comedianIds.
  matchVenuesAndGigs: function(p) { 

    const matchingVenues = this.filter((venue) => {
      return venue.get('gigs').filteredByFormValues(p).length >= 1;
    });

    return new VenueCollection(matchingVenues);
  }
});