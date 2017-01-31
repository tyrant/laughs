function FAQs() {

  // Just static HTML, no state or computation here.
  return (
    <div className="panel-group" id="faq_accordion" role="tablist" aria-multiselectable="true">
      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingOne">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
              My favourite comedian isn't on here! What gives?
            </a>
          </h4>
        </div>
        <div id="collapseOne" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
          <div className="panel-body">
            <p>
              And here's me claiming your favourite comic is already here! My bad :( Thing is, I have to write a separate script to get the data for each comic, and that shit takes time. I'm adding them as fast as I can. If you'd like me to bump your comic up the list, flick me an email at epicschnozz[at]gmail[dot]com.
            </p>
            <p>
              That said, sometimes I've tried to add comedians and couldn't. Sarah Millican, Ricky Gervais, others, they're just not touring right now. <a href="http://www.sarahmillican.co.uk/live-tour">See?</a>
            </p>
            <p>
              Then again, I did write these words way back in January 2017. In whatever Star Trek future you're reading this in, maybe she's started touring again. 
            </p>
          </div>
        </div>
      </div>

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingTwo">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
              This comedy-search app thingy seems kinda cool. Can I install it on my own website?
            </a>
          </h4>
        </div>
        <div id="collapseTwo" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
          <div className="panel-body">
            <p>
              Please do! Here's how:
            </p>
            <p>
              First, adjust the map, search form and tabs to display the way you'd like. You'll notice that with each tweak, the URL changes to match. Once you're satisfied, copy it.
            </p>
            <p>
              Second, add this code to your site:
            </p>
            <p>
              <code>
                &lt;iframe<br/>
                  width="<em>Your pixel width here</em>"<br/>
                  height="<em>Your pixel height here</em>"<br/>
                  src="<em>Your copied-and-pasted URL here</em>"&gt;<br/>
                &lt;/iframe&gt;
              </code>
            </p>
            <p>
              And that's it! The embedded widget will behave exactly as a normal web page.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}


class VenueInfo extends React.Component {

  constructor(props) {
    super(props);

  }


  render() {
    const venue = this.props.currentVenue;

    if (venue instanceof Venue) {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h4 className="panel-title">
              Gigs matching your search at {venue.get('name')}
            </h4>
          </div>
          <div className="panel-body">
            <ul>
              {venue.get('filteredGigs').sortedByTime().map((gig) =>
                <li key={gig.id} data-gig-id={gig.id}>
                  <img width="100" height="100" src={gig.get('comedians').at(0).get('mugshot_url')} />
                  {gig.get('comedians').at(0).get('name')}<br />
                  {gig.get('time').format('Do MMMM YYYY')}<br />
                  <a className="btn btn-lg btn-success" href={gig.bookingUrl()}>Buy Tickets</a>
                </li>
              )}
            </ul>
          </div>
        </div>
      );

    } else {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h4 className="panel-title">
              Click on a venue marker to display its gig list here.
            </h4>
          </div>
        </div>
      );
    }
  }
}


class SearchForm extends React.Component {

  constructor(props) {
    super(props);

    this.handleSearchFormChange = this.handleSearchFormChange.bind(this);
  }

  // Fire up the select2 and the two datetimepickers.
  componentDidMount() {

    // Fire up the select2 box.
    $('#comedians').select2({
      placeholder: 'Click or type to find gigs by...',
      templateResult: (comic) => {
        if (comic.element) {
          return $('<span><img width="100" height="100" src="' + comic.element.attributes['data-src'].nodeValue + '">&nbsp;&nbsp;' + comic.text + '</span>');
        }
      },
      templateSelection: (comic) => {
        if (comic.element) {
          return $('<span>&nbsp;<img width="60" height="60" title="' + '" src="' + comic.element.attributes['data-src'].nodeValue + '"></span>');
        }
      }
    });

    $('#start_date').datetimepicker({
      format:      'DD MMM YYYY',
      defaultDate: this.props.startDate,
    });

    $('#end_date').datetimepicker({ 
      format:      'DD MMM YYYY',
      defaultDate: this.props.endDate,
    });

    $('#start_date, #end_date').on('dp.change', () => { 
      this.handleSearchFormChange(); 
    });
    $('#comedians').on('change', () => { 
      this.handleSearchFormChange(); 
    });
  }

  // Bit of munging. Change [[key, value], ...] to { key: value, ... }
  handleSearchFormChange() {
    const values = $('#filter').serializeArray();

    const startDate = _(values).find((v) => {
      return v.name == 'start_date';
    }).value;
    const endDate = _(values).find((v) => {
      return v.name == 'end_date';
    }).value;
    const comedians = _(values).chain().filter((v) => {
      return v.name == 'comedians[]';
    }).map((v) => {
      return v.value;
    }).value();

    // Reminder: these are still the raw form values! Just in object form,
    // not serialized array form.
    const betterValues = {
      startDate: startDate,
      endDate:   endDate,
      comedians: comedians,
    };

    // Quick preprocessing: for both dates, turn 27 Jan 2017 into 2017-01-27.
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec'];

    const start = betterValues.startDate.split(' ');
    startMonth = _(months).indexOf(start[1]) + 1;
    startMonth = startMonth.toString().length == 1 ? '0' + startMonth : startMonth; // My kingdom for a padStart()
    betterStart = start[2] + '-' + startMonth + '-' + start[0];

    betterValues.startDate = betterStart;

    const end = betterValues.endDate.split(' ');
    endMonth = _(months).indexOf(end[1]) + 1;
    endMonth = endMonth.toString().length == 1 ? '0' + endMonth : endMonth; 
    betterEnd = end[2] + '-' + endMonth + '-' + end[0];
    betterValues.endDate = betterEnd;
    
    this.props.handleSearchFormChange(betterValues);
  }

  render() {
    return (
      <form id="filter" method="get" data-remote="true" action="/venues">

        <div className="form-group">
          <select 
            name="comedians[]" 
            id="comedians" 
            className="form-control" 
            multiple="multiple" 
            defaultValue={this.props.selectedComedians.pluck('id')}
            style={{width: '100%'}}>
              {this.props.allComedians.map((comedian) =>
                <option 
                  key={comedian.id} 
                  value={comedian.id} 
                  data-src={comedian.get('mugshot_url')}
                  >
                  {comedian.get('name')}
                </option>
              )}
          </select>
        </div>

        <div className="row">
          <div className="col-xs-6 start-container">
            <div className="form-group">
              <div className="input-group date" id="start_date">
                <span className="input-group-addon">
                  <span className="glyphicon glyphicon-calendar"></span>
                  From
                </span>
                <input type="text" name="start_date" className="form-control" />
              </div>
            </div>
          </div>

          <div className="col-xs-6 end-container">
            <div className="form-group">
              <div className="input-group date" id="end_date">
                <span className="input-group-addon">
                  <span className="glyphicon glyphicon-calendar"></span>
                  Until
                </span>
                <input type="text" name="end_date" className="form-control" />
              </div>
            </div>
          </div>
        </div>
      </form>
    );
  }
}

class Overlay extends React.Component {

  constructor(props) {
    super(props);
  }


  // Fire up an event handler for changing tabs.
  componentDidMount() {
    $('#overlay a[data-toggle="tab"]').on('shown.bs.tab', (e) => {
      let newTab = $(e.target).attr('aria-controls');
      this.props.handleTabChange(newTab);
    });
  }

  render() {
    return (
      <div id="overlay" className="container" style={{display: this.props.showOverlay ? 'block' : 'none'}}>

        <ul className="nav nav-tabs" role="tablist">
          <li role="presentation" className={this.props.tab == 'faq' ? 'active' : ''}>
            <a href="#faq" aria-controls="faq" role="tab" data-toggle="tab">FAQs</a>
          </li>
          <li role="presentation" className={this.props.tab == 'gigs' ? 'active' : ''}>
            <a href="#gigs" aria-controls="gigs" role="tab" data-toggle="tab">Gigs</a>
          </li>
          <li role="presentation" className={this.props.tab == 'search' ? 'active' : ''}>
            <a href="#search" aria-controls="search" role="tab" data-toggle="tab">Search</a>
          </li>
        </ul>

        <div className="tab-content">
          <div role="tabpanel" className={this.props.tab == 'search' ? 'tab-pane active' : 'tab-pane'} id="search">
            <SearchForm 
              allComedians={this.props.allComedians} 
              selectedComedians={this.props.selectedComedians}
              startDate={this.props.startDate}
              endDate={this.props.endDate}
              handleSearchFormChange={this.props.handleSearchFormChange}
            />
          </div>
          <div role="tabpanel" className={this.props.tab == 'gigs' ? 'tab-pane active' : 'tab-pane'} id="gigs">
            <VenueInfo 
              currentVenue={this.props.currentVenue}
            />
          </div>
          <div role="tabpanel" className={this.props.tab == 'faq' ? 'tab-pane active' : 'tab-pane'} id="faq">
            <FAQs />
          </div>
        </div>
      </div>
    );
  }
}


class Map extends React.Component {

  constructor(props) {
    super(props);

    this.markers = [];

    this.handleMapChange = this.handleMapChange.bind(this);
    this.addNewVenuesToMap = this.addNewVenuesToMap.bind(this);
    this.removeOldVenuesFromMap = this.removeOldVenuesFromMap.bind(this);
  }

  componentDidMount() {
    // Fire up the map.
    this.map = new google.maps.Map(this.refs.map, {
      center: new google.maps.LatLng(this.props.lat, this.props.lng),
      zoom:   this.props.zoom
    });

    // Fire up a few event listeners.
    this.map.addListener('dragend', this.handleMapChange);
    this.map.addListener('zoom_changed', this.handleMapChange); 
  }

  // We only want to update the map if the venue list has changed.
  // _.isEqual works on primitives, not objects, it seems, so pluck both arrays' IDs.
  shouldComponentUpdate(nextProps, nextState) {

    oldVenueIds = this.props.selectedVenuesAndGigs.pluck('id');
    newVenueIds = nextProps.selectedVenuesAndGigs.pluck('id');

    return !_.isEqual(oldVenueIds, newVenueIds);
  }


  // Compare prevProps.venues to this.props.venues, see which are newly added,
  // which have gone; add the new ones to the map, and delete the old markers.
  componentDidUpdate(prevProps, prevState) {

    // Rr! _.difference() only works on primitives.
    oldVenueIds = prevProps.selectedVenuesAndGigs.pluck('id');
    newVenueIds = this.props.selectedVenuesAndGigs.pluck('id');

    venueIdsToRemove = _(oldVenueIds).difference(newVenueIds);
    venueIdsToAdd = _(newVenueIds).difference(oldVenueIds);

    this.addNewVenuesToMap(venueIdsToAdd);
    this.removeOldVenuesFromMap(venueIdsToRemove);
  }

  addNewVenuesToMap(venueIds) {

    // Add new markers.
    venueIds.forEach((venueId) => {

      let venue = this.props.selectedVenuesAndGigs.find((venue) => { 
        return venue.id == venueId; 
      });

      let marker = new google.maps.Marker({
        position: new google.maps.LatLng(venue.get('latitude'), venue.get('longitude')),
        title:    venue.get('name') + ', ' + venue.get('readable_address'),
        map:      this.map
      });

      marker.addListener('click', (e) => {
        this.props.handleMarkerClick(marker.venue);
      });

      marker.setMap(this.map);
      marker.venue = venue;
      this.markers.push(marker);
    });
  }

  removeOldVenuesFromMap(venueIds) {

    venueIds.forEach((venueId) => {
      var marker = _(this.markers).find((marker) => { 
        return marker.venue.id == venueId; 
      });
      marker.setMap(null);
    });

    this.markers = _(this.markers).filter((marker) => {
      return !_(venueIds).contains(marker.venue.id);
    });
  }

  // Called on events dragend and zoom_changed. Return latitude, longitude and zoom values.
  handleMapChange() {
    this.props.handleMapChange({
      lat:  this.map.getCenter().lat(),
      lng:  this.map.getCenter().lng(),
      zoom: this.map.getZoom(),
    });
  }

  render() {
    return <div id="map" ref="map"></div>;
  }
}


class Banner extends React.Component {

  constructor(props) {
    super(props);

    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(e) {
    e.preventDefault();
    this.props.handleOverlayToggleClick();
  }

  render() {
    return (
      <div id="banner">
        <a id="home" className="btn btn-default" href="/">
          <i className="glyphicon glyphicon-home"></i>
        </a>
        <span id="blurb">Find your favourite comics' gigs.</span>
        <a id="toggle_overlay" className="btn btn-default" onClick={this.handleClick}>
          <span className="glyphicon glyphicon-list" aria-hidden="true"></span>
        </a>
      </div>
    );
  }
}


class EverythingElse extends React.Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div id="everything_else">
        <Map
          lat={this.props.lat}
          lng={this.props.lng}
          zoom={this.props.zoom}
          selectedVenuesAndGigs={this.props.selectedVenuesAndGigs}
          handleMapChange={this.props.handleMapChange}
          handleMarkerClick={this.props.handleMarkerClick}
        />
        <Overlay
          showOverlay={this.props.showOverlay}

          selectedComedians={this.props.selectedComedians}
          allComedians={this.props.allComedians}
          startDate={this.props.startDate}
          endDate={this.props.endDate}
          handleSearchFormChange={this.props.handleSearchFormChange}
          tab={this.props.tab}
          handleTabChange={this.props.handleTabChange}

          currentVenue={this.props.currentVenue}
        />
      </div>
    );
  }
}


class Laughs extends React.Component {
  
  // We fire up Backbone, grab our URL params, grab our Venue JSON, and build a Backbone collection.
  constructor() {
    super();

    // Set up our functions' 'this' scopes.
    this.fetchMoreVenues = this.fetchMoreVenues.bind(this);

    this.handleSearchFormChange = this.handleSearchFormChange.bind(this);
    this.handleOverlayToggleClick = this.handleOverlayToggleClick.bind(this);
    this.handleMapChange = this.handleMapChange.bind(this);
    this.handleMarkerClick = this.handleMarkerClick.bind(this);
    this.handleTabChange = this.handleTabChange.bind(this);

    this.getUrlData = this.getUrlData.bind(this);
    this.setUrlData = this.setUrlData.bind(this);
    this.loadStateFromUrl = this.loadStateFromUrl.bind(this);
    this.selectedVenuesAndGigs = this.selectedVenuesAndGigs.bind(this);


    // And we're off! Set shit up.
    this.state = this.loadStateFromUrl();

    this.fetchMoreVenues();
  }


  // Whenever we call setState, we want to update the URL with the new goodies.
  componentDidUpdate() {
    this.setUrlData();
  }


  // Grab new venue info and append the new models to allVenues. 
  // When querying, we need the comedian IDs, start/end dates.
  // No point in querying the same venues multiple times, either - send a list of
  // their IDs.
  // Later: lat/lng bounds!
  fetchMoreVenues() {

    let data = {
      comedians:  this.state.selectedComedians.pluck('id'),
      start_date: this.state.startDate.format('YYYY-MM-DD'),
      end_date:   this.state.endDate.format('YYYY-MM-DD'),
      without:    this.state.allVenues.pluck('id'),
    };

    if (this.state.currentVenue != 'none') {
      data.with = [this.state.currentVenue];
    }

    // Attempting to add a JSON object with the same ID twice will get rejected.
    $.getJSON('/venues', data).done((venuesJson) => {
      let allVenues = this.state.allVenues;
      let currentVenue = null;

      allVenues.add(venuesJson);

      if (this.state.currentVenue != 'none') {
        currentVenue = allVenues.find(function(v) { return v.id == data.with; });
      } else {
        currentVenue = 'none';
      }

      this.setState({
        currentVenue: currentVenue,
        allVenues:    allVenues,
      });
    });
  }


  // selectedVenuesAndGigs is the result of applying the search form filters
  // to allVenues, and to each of their gigs. It's only ever called from render().
  // This function is local venue caching, basically.
  selectedVenuesAndGigs() {
    let comedians = [];
    if (this.state.selectedComedians.length > 0) {
      comedians = this.state.selectedComedians;
    } else {
      comedians = this.state.allComedians;
    }

    // Return all venues with at least one gig with start > time > end, 
    // and with gig.comedians including comedianIds.
    return this.state.allVenues.matchVenuesAndGigs({
      start:     this.state.startDate,
      end:       this.state.endDate,
      comedians: comedians
    });
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

    let selectedComedians = this.state.allComedians.filter((c) => {
      return _(values.comedians).contains(c.id.toString());
    });

    this.setState({
      selectedComedians: new ComedianCollection(selectedComedians),
      startDate:         moment(values.startDate),
      endDate:           moment(values.endDate),
    });

    this.fetchMoreVenues();
  }


  // Update our state with the new map values. And round off lat/lng, let's not go nuts.
  handleMapChange(newValues) {
    this.setState({
      lat:  newValues.lat.toFixed(6),
      lng:  newValues.lng.toFixed(6),
      zoom: newValues.zoom,
    });

    // When we implement latlngbounds filtering, uncomment this.
    //this.fetchMoreVenues();
  }


  // If the user clicks on a marker, setState to its venue, 
  // the better to display its venue's gig list.
  handleMarkerClick(venue) {
    this.setState({
      currentVenue: venue,
      tab:          'gigs',
      showOverlay:  true,
    });
  }


  handleTabChange(newTab) {
    this.setState({
      tab: newTab
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
      startDate:         moment(),
      endDate:           moment().add(1, 'year'),
      showOverlay:       true,
      tab:               'search',
    };

    let urlData = this.getUrlData();

    return {
      lat:               urlData.lat ? urlData.lat : defaults.lat,
      lng:               urlData.lng ? urlData.lng : defaults.lng,
      zoom:              urlData.zoom ? urlData.zoom : defaults.zoom,
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
      tab:               pathObj.t,
      selectedComedians: selectedComedians.length > 0 ? new ComedianCollection(selectedComedians) : null, 
      lat:               parseFloat(pathObj.a) || null,
      lng:               parseFloat(pathObj.n) || null,
      zoom:              parseInt(pathObj.z) || null,
      showOverlay:       pathObj.o != 'f',
      startDate:         pathObj.s ? moment(pathObj.s) : null,
      endDate:           pathObj.e ? moment(pathObj.e) : null,
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
      t: this.state.tab,
      c: this.state.selectedComedians.pluck('id').join(','),
      a: this.state.lat,
      n: this.state.lng,
      z: this.state.zoom,
      o: this.state.showOverlay ? 't' : 'f',
      s: this.state.startDate.format('YYYY-MM-DD'),
      e: this.state.endDate.format('YYYY-MM-DD'),
    };
    const pairs = _(pathObj).map((v, k) => { return k + '=' + v; });
    window.history.pushState(pairs, 'Updated state', '?' + pairs.join('&'));
  }


  // Default: we render the map and overlay. 
  // If we've got a venue, render its view instead.
  render() {

    return (
      <div>
        <Banner 
          handleOverlayToggleClick={this.handleOverlayToggleClick}
        />
        <EverythingElse 
          showOverlay={this.state.showOverlay}

          lat={this.state.lat}
          lng={this.state.lng}
          zoom={this.state.zoom}
          selectedVenuesAndGigs={this.selectedVenuesAndGigs()}
          handleMapChange={this.handleMapChange}
          handleMarkerClick={this.handleMarkerClick}

          selectedComedians={this.state.selectedComedians}
          allComedians={this.state.allComedians}
          startDate={this.state.startDate}
          endDate={this.state.endDate}
          handleSearchFormChange={this.handleSearchFormChange}
          tab={this.state.tab}
          handleTabChange={this.handleTabChange}

          currentVenue={this.state.currentVenue}
        />
      </div>
    );
  }
}
