var Comedian = Supermodel.Model.extend();

var Spot = Supermodel.Model.extend();

var Gig = Supermodel.Model.extend({

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


var Venue = Supermodel.Model.extend();


var ComedianCollection = Backbone.Collection.extend({

  model: function(attrs, options) {
    return Comedian.create(attrs, options);
  }
});

var SpotCollection = Backbone.Collection.extend({

  model: function(attrs, options) {
    return Spot.create(attrs, options);
  }
})

var GigCollection = Backbone.Collection.extend({

  model: function(attrs, options) {
    return Gig.create(attrs, options);
  },


  sortedByTime: function() {
    const sortedGigs = this.sortBy('time');
    return new GigCollection(sortedGigs);
  },


  // Receive: comedians, start/end timestamps, and gig filter ('s'/'a').
  // Comedians is optional.
  filteredByFormValues: function(p) {

    if (p.gigFilter == 's') {

      let comedianIds = null;

      if (p.comedians) {
        comedianIds = p.comedians.pluck('id');
      }

      const gigs = this.filter((gig) => {
        let n = moment().unix()

        const timeMatch = p.start < gig.get('time') && gig.get('time') < p.end;

        let comediansMatch = null;
        if (p.comedians) {
          const comedians = gig.spots().map((s) => s.comedian());
          const gigComedianIds = _(comedians).pluck('id');

          comediansMatch = _.intersection(comedianIds, gigComedianIds).length > 0;
        } else {
          comediansMatch = true;
        }

        return timeMatch && comediansMatch;
      });

      return new GigCollection(gigs); 

    } else if (p.gigFilter == 'a') {
      return this;
    }
  },
});


var VenueCollection = Backbone.Collection.extend({

  model: function(attrs, options) {
    return Venue.create(attrs, options);
  },


  // Return all venues bounded by the lat/lng ne/sw pair supplied.
  // Only ever called from laughs.fetchMoreVenues().
  within: function(p) {

    const matchingVenues = this.filter((venue) => {
      const lat = venue.get('latitude');
      const lng = venue.get('longitude');

      const matchesLat = p.sw_lat < lat && lat < p.ne_lat;

      // Allow for straddling the international date line!
      let matchesLng = false;
      if (p.sw_lng < p.ne_lng)
        matchesLng = p.sw_lng < lng && lng < p.ne_lng;
      else 
        matchesLng = p.sw_lng < lng || lng < p.ne_lng;

      //console.debug('lat=', lat, 'lng=', lng, 'sw_lat=', p.sw_lat, 'sw_lng=', p.sw_lng, 'ne_lat=', p.ne_lat, 'ne_lng=', p.ne_lng, 'matchesLat=', matchesLat, 'matchesLng=', matchesLng, 'matches=', matchesLat && matchesLng)

      return matchesLat && matchesLng;
    });

    return new VenueCollection(matchingVenues);
  },


  // Receive a comedian list, start date, end date, and gig filter.
  // Return a filtered list of allVenues, where each venue has at least one gig
  // between p.start and p.end, and that gig's comedian list must have at least
  // one comedian within p.comedianIds.
  matchVenuesAndGigs: function(p) { 

    const matchingVenues = this.filter((venue) => {
      return venue.gigs().filteredByFormValues(p).length >= 1;
    });

    return new VenueCollection(matchingVenues);
  }

});


Comedian.has().many('spots', {
  collection: SpotCollection,
  inverse:    'comedian',
});

Spot.has().one('comedian', {
  model:   Comedian,
  inverse: 'spots'
});

Spot.has().one('gig', {
  model:   Gig,
  inverse: 'spots'
});

Gig.has().many('spots', {
  collection: SpotCollection,
  inverse:    'gig',
});

Gig.has().one('venue', {
  model:    Venue,
  inverse: 'gigs',
});

Venue.has().many('gigs', {
  collection: GigCollection,
  inverse:    'venue',
});