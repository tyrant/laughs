var Alert = Supermodel.Model.extend({
  urlRoot: '/alerts',
  validate: function(attrs, options) {
    if (!attrs.readable_address)
      return "You'll need to select a city to get alerts for";
    else
      return undefined;
  },


});

var ComedianAlert = Supermodel.Model.extend({
  url: '/comedian_alerts',
});

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


var AlertCollection = Backbone.Collection.extend({

  url: '/alerts',
  model: function(attrs, options) {
    return Alert.create(attrs, options);
  }
});

var ComedianAlertCollection = Backbone.Collection.extend({

  model: function(attrs, options) {
    return ComedianAlert.create(attrs, options);
  }
});

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

        const timeMatch = p.start < gig.get('time') && gig.get('time') < p.end;

        let comediansMatch = null;
        if (p.comedians) {
          const comedians = gig.spots().map(s => s.comedian());
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
  }

});


Comedian.has().many('spots', {
  collection: SpotCollection,
  inverse:    'comedian',
});

Comedian.has().many('comedian_alerts', {
  collection: ComedianAlertCollection,
  inverse:    'comedian',
});

ComedianAlert.has().one('comedian', {
  model:   Comedian,
  inverse: 'comedian_alerts'
});

ComedianAlert.has().one('alert', {
  model:   Alert,
  inverse: 'comedian_alerts'
});

Alert.has().many('comedian_alerts', {
  collection: ComedianAlertCollection,
  inverse:    'alert'
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

