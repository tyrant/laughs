window.Comedian = Backbone.Model.extend({

});

window.Gig = Backbone.Model.extend({

  initialize: function(params) {
    this.set({
      comedians: new ComedianCollection(params.comedians),
      time:      moment(params.time),
    });
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
  model: Gig
});

window.VenueCollection = Backbone.Collection.extend({
  model: Venue

});