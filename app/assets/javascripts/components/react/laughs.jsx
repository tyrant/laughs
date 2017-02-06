class Laughs extends React.Component {
  
  // We fire up Backbone, grab our URL params, grab our Venue JSON, and build a Backbone collection.
  constructor() {
    super();

    // Set up our functions' 'this' scopes.
    this.fetchMoreVenues = this.fetchMoreVenues.bind(this);
    this.comedians = this.comedians.bind(this);
    this.selectedVenuesAndGigs = this.selectedVenuesAndGigs.bind(this);
    this.gigFilters = this.gigFilters.bind(this);
    this.bounds = this.bounds.bind(this);

    this.handleSearchFormChange = this.handleSearchFormChange.bind(this);
    this.handleOverlayToggleClick = this.handleOverlayToggleClick.bind(this);
    this.handleMapChange = this.handleMapChange.bind(this);
    this.handleMarkerClick = this.handleMarkerClick.bind(this);
    this.handleTabChange = this.handleTabChange.bind(this);
    this.handleGigFilterChange = this.handleGigFilterChange.bind(this);

    this.getUrlData = this.getUrlData.bind(this);
    this.setUrlData = this.setUrlData.bind(this);
    this.loadStateFromUrl = this.loadStateFromUrl.bind(this);


    // And we're off! Set shit up.
    this.state = this.loadStateFromUrl();

    // When our <Map> finishes mounting, it squirts back its state, triggering
    // this.handleMapChange(), calling this.fetchMoreVenues(). 
  }


  // Whenever we call setState, we want to update the URL with the new goodies.
  componentDidUpdate() {
    this.setUrlData();
  }


  // Grab new venue info and append the new models to allVenues. 
  // When querying, we need the comedian IDs, start/end dates.
  // No point in querying the same venues multiple times, either - send a list of
  // their IDs.
  fetchMoreVenues() {

    // Grab the venues to be displayed within the map's bounds right now,
    // and that are already loaded. No point in fetching them a second time -
    // add their IDs to the 'without' list.
    const venuesVisibleAndLoaded = this.state.allVenues.within(this.bounds());

    let data = _(this.bounds()).extend({
      comedians:  this.state.selectedComedians.pluck('id'),
      start_date: this.state.startDate,
      end_date:   this.state.endDate,
      without:    venuesVisibleAndLoaded.pluck('id'),
    });

    // Fiddly bit here. On page load, if the current venue is set, we want to 
    // show its gigs - but it's not loaded as a Backbone model until the Ajax
    // request below is complete. So if urlData.currentVenue is a number, and
    // it's not already a Backbone object, set data.with to currentVenue.
    if (this.state.currentVenue != 'none' && !(this.state.currentVenue instanceof Venue)) {
      data.with = [this.state.currentVenue];
    }

    this.setState({
      blurb: 'Loading more gigs...'
    });

    // Attempting to add a JSON object with the same ID twice will get rejected.
    $.getJSON('/venues', data).done((venuesJson) => {

      let allVenues = this.state.allVenues;
      let currentVenue = this.state.currentVenue;

      allVenues.add(venuesJson);

      if (!(this.state.currentVenue instanceof Venue)) {
        if (this.state.currentVenue != 'none') {
          currentVenue = allVenues.find(function(v) { return v.id == data.with; });
        } else {
          currentVenue = 'none';
        }
      }

      this.setState({
        currentVenue: currentVenue,
        allVenues:    allVenues,
      });
    });
  }


  // Quick shorthand. If our search form's comedians list is empty, default to all of them.
  comedians() {
    if (this.state.selectedComedians.length > 0) {
      return this.state.selectedComedians;
    } else {
      return this.state.allComedians;
    }
  }


  // selectedVenuesAndGigs is the result of applying the search form filters
  // to allVenues, and to each of their gigs. It's only ever called from render().
  // This function is local venue caching, basically.
  selectedVenuesAndGigs() {

    // Filter first by venues with at least one gig with start > time > end, 
    // and with gig.comedians including comedians().
    return this.state.allVenues.matchVenuesAndGigs({
      start:     this.state.startDate,
      end:       this.state.endDate,
      comedians: this.comedians(),
      gigFilter: 's',

    // Filter second by map bounds.
    }).within(this.bounds());
  }


  // Quick shorthand for the state arguments the gig filter radio buttons need.
  gigFilters() {
    return {
      start:     this.state.startDate,
      end:       this.state.endDate,
      comedians: this.comedians(),
      gigFilter: this.state.gigFilter,
    };
  }


  // Another quick shorthand.
  bounds() {
    if (this.state.bounds)
      return {
        ne_lat: this.state.bounds.getNorthEast().lat(),
        ne_lng: this.state.bounds.getNorthEast().lng(),
        sw_lat: this.state.bounds.getSouthWest().lat(),
        sw_lng: this.state.bounds.getSouthWest().lng(),
      };
    else
      return {
        ne_lat: 90,
        ne_lng: 180,
        sw_lat: -90,
        sw_lng: -180,
      };
  }


  // Event handler.
  handleOverlayToggleClick() {
    const overlay = this.state.showOverlay;
    this.setState({
      showOverlay: !overlay,
    });
  }


  // The user's changed the search form values. Hit up the server for whatever new 
  // venues we need to add to our cache, then update the state with comedians, start
  // and end dates.
  handleSearchFormChange(values) {

    const selectedComedians = this.state.allComedians.filter((c) => {
      return _(values.comedians).contains(c.id.toString());
    });

    this.setState({
      selectedComedians: new ComedianCollection(selectedComedians),
      startDate:         moment(values.startDate).unix(),
      endDate:           moment(values.endDate).unix(),
    });

    this.fetchMoreVenues();
  }


  // Update our state with the new map values. And round off lat/lng, let's not go nuts.
  handleMapChange(newValues) {
    this.setState({
      lat:    newValues.center.lat().toFixed(6),
      lng:    newValues.center.lng().toFixed(6),
      zoom:   newValues.zoom,
      bounds: newValues.bounds,
    });

    this.fetchMoreVenues();
  }


  // If the user clicks on a marker, setState to its venue, 
  // the better to display its venue's gig list.
  handleMarkerClick(venue) {
    this.setState({
      currentVenue: venue,
      tab:          'gigs',
      showOverlay:  true,
      gigFilter:    's',
    });
  }


  handleTabChange(newTab) {
    this.setState({
      tab: newTab,
    });
  }


  handleGigFilterChange(newValue) {
    this.setState({
      gigFilter: newValue,
    });
  }


  // Only ever called on page load. We load what we can from the URL, and set the rest
  // from our defaults.
  loadStateFromUrl() {

    let allComedians = new ComedianCollection();
    allComedians.reset(window.allComedians);

    // If there's zilch in the URL, this is a decent default state for our app.
    // The URL's various bits and bobs overwrite this.
    let defaults = {
      lat:               49,
      lng:               3,
      zoom:              5,
      selectedComedians: new ComedianCollection(), 
      allVenues:         new VenueCollection(), 
      currentVenue:      null,
      bounds:            null,
      startDate:         moment().unix(),
      endDate:           moment().add(1, 'year').unix(),
      showOverlay:       true,
      tab:               'search',
      gigFilter:         's',
      blurb:             'Find your favourite gigs!',
    };

    let urlData = this.getUrlData();

    return {
      lat:               urlData.lat ? urlData.lat : defaults.lat,
      lng:               urlData.lng ? urlData.lng : defaults.lng,
      zoom:              urlData.zoom ? urlData.zoom : defaults.zoom,
      bounds:            defaults.bounds,
      allComedians:      allComedians,
      selectedComedians: urlData.selectedComedians 
                          ? urlData.selectedComedians 
                          : defaults.selectedComedians,
      allVenues:         defaults.allVenues,
      currentVenue:      urlData.currentVenue,
      startDate:         urlData.startDate ? urlData.startDate : defaults.startDate,
      endDate:           urlData.endDate ? urlData.endDate : defaults.endDate,
      showOverlay:       urlData.showOverlay != null ? urlData.showOverlay : defaults.showOverlay,
      tab:               urlData.tab ? urlData.tab : defaults.tab,
      gigFilter:         urlData.gigFilter || 's',
      blurb:             defaults.blurb,
    };
  }

  // Reverse of setUrlData. Grab the querystring in the format below,
  // generate new Backbone collections and Moment objects from the ID string,
  // and return.
  getUrlData() {

    let pathObj = null;
    let selectedComedians = null;

    if (window.location.search) {
      // Grab our URL data, snip off the leading ?, convert into ['foo=bar', 'bar=baz'],
      // then into { foo: 'bar', bar: 'baz' }.
      const key_values = window.location.search.substr(1).split('&').map((pair) => { 
        const p = pair.split('=');
        return [p[0], p[1]];
      });

      // Great. Now it's back into an object in the form inside setUrlData().
      pathObj = _(key_values).object();

      // Transfoms a list of ID characters into an array of Comedian objects.
      const comedianIds = pathObj.c.split(',');

      selectedComedians = allComedians.filter((c) => {
        return _(comedianIds).contains(c.id.toString()); 
      });

    } else {
      pathObj = {};
      selectedComedians = [];
    }

    return {
      currentVenue:      pathObj.v || 'none',
      gigFilter:         pathObj.g || 's',
      tab:               pathObj.t,
      selectedComedians: selectedComedians.length > 0 ? new ComedianCollection(selectedComedians) : null, 
      lat:               parseFloat(pathObj.a) || null,
      lng:               parseFloat(pathObj.n) || null,
      zoom:              parseInt(pathObj.z) || null,
      showOverlay:       pathObj.o != 'f',
      startDate:         pathObj.s ? pathObj.s : null,
      endDate:           pathObj.e ? pathObj.e : null,
    };
  }

  // URL. It stores the current venue (if any); comedian IDs; 
  // latitude; longitude; overlay display; start date; end date.
  // It gets the info from this.state.
  // It's an object, in the order above, in the following format:
  // ?v=:id&c=:ids&a=:lat...
  setUrlData() {
    const pathObj = {
      v: this.state.currentVenue instanceof Venue ? this.state.currentVenue.id : 'none',
      g: this.state.gigFilter ? this.state.gigFilter : 's',
      t: this.state.tab,
      c: this.state.selectedComedians.pluck('id').join(','),
      a: this.state.lat,
      n: this.state.lng,
      z: this.state.zoom,
      o: this.state.showOverlay ? 't' : 'f',
      s: this.state.startDate,
      e: this.state.endDate,
    };
    const pairs = _(pathObj).map((v, k) => k + '=' + v);
    window.history.pushState(pairs, 'Updated state', '?' + pairs.join('&'));
  }


  // Default: we render the map and overlay. 
  // If we've got a venue, render its view instead.
  render() {
    const selectedVenuesAndGigs = this.selectedVenuesAndGigs();
    const gigFilters = this.gigFilters();

    const gigCounts = selectedVenuesAndGigs.map(v => v.gigs().length);
    const gigSum = _(gigCounts).reduce((m, n) => { return m+n; }, 0);

    const blurb = "Showing " + selectedVenuesAndGigs.length + " venues, hosting " + gigSum + " gigs";

    return (
      <div>
        <Banner 
          handleOverlayToggleClick={this.handleOverlayToggleClick}
          blurb={blurb}
        />

        <div id="everything_else">
          <Map
            lat={this.state.lat}
            lng={this.state.lng}
            zoom={this.state.zoom}
            selectedVenuesAndGigs={selectedVenuesAndGigs}
            handleMapChange={this.handleMapChange}
            handleMarkerClick={this.handleMarkerClick}
          />
          <Overlay
            showOverlay={this.state.showOverlay}

            selectedComedians={this.state.selectedComedians}
            allComedians={this.state.allComedians}
            startDate={this.state.startDate}
            endDate={this.state.endDate}
            handleSearchFormChange={this.handleSearchFormChange}
            tab={this.state.tab}
            handleTabChange={this.handleTabChange}

            gigFilters={gigFilters}
            handleGigFilterChange={this.handleGigFilterChange}

            currentVenue={this.state.currentVenue}
          />
        </div>
      </div>
    );
  }
}