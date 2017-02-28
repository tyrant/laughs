class Map extends React.Component {


  constructor(props) {
    super(props);

    this.markers = [];

    this.handleMapChange = this.handleMapChange.bind(this);
    this.addNewVenuesToMap = this.addNewVenuesToMap.bind(this);
    this.addNewVenueGroupsToMap = this.addNewVenueGroupsToMap.bind(this);

    this.getIdsFromVenuesAndGroups = this.getIdsFromVenuesAndGroups.bind(this);
    this.arrayDifference = this.arrayDifference.bind(this);
  }


  componentDidMount() {

    // Fire up the map.
    this.map = new google.maps.Map(this.refs.map, {
      center:    new google.maps.LatLng(this.props.lat, this.props.lng),
      zoom:      this.props.zoom,
      mapTypeId: 'terrain'
    });

    // Fire up the clusterer.
    this.clusterer = new MarkerClusterer(this.map, [], {
      imagePath: '/m',
      gridSize:  45,
    });

    // Fire up a few event listeners.
    this.map.addListener('dragend', this.handleMapChange);
    this.map.addListener('zoom_changed', this.handleMapChange);

    // A little bit of fiddliness to fetch more venues after the window size finishes changing.
    let resizeTimer;
    google.maps.event.addDomListener(window, 'resize', () => {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(() => {
        this.handleMapChange();
      }, 500);
    });

    // And fire map change just once. 
    google.maps.event.addListenerOnce(this.map, 'idle', () => {
      this.handleMapChange();
    });
  }


  // What it says on the tin.
  getIdsFromVenuesAndGroups(venues) {
    return {
      venues: venues.venues.pluck('id'),
      groups: _(venues.groups).map(venue => venue.ids),
    };
  } 


  // Receive two arrays of arrays of integers. Remove all integer arrays
  // from the first that are also in the second, and return the remainder.
  arrayDifference(array1, array2) {

    // Filter array1's entries by whether a1 doesn't have a member of array2 equal to it.
    return _(array1).filter((a1) => {

      // Not a single member of array2 equals a1? Great. Filter passed.
      return !_(array2).any(a2 => _(a1).isEqual(a2));
    });
  }


  // We only want to update the map if the venue list has changed.
  shouldComponentUpdate(nextProps, nextState) {

    oldIds = this.getIdsFromVenuesAndGroups(this.props.venues);
    newIds = this.getIdsFromVenuesAndGroups(nextProps.venues);

    return !_.isEqual(oldIds, newIds);
  }


  // Compare prevProps.venues to this.props.venues, see which are newly added,
  // which have gone; add the new ones to the map, and delete the old markers.
  componentDidUpdate(prevProps, prevState) {

    newIds = this.getIdsFromVenuesAndGroups(this.props.venues);

    this.removeAllMarkers();

    this.addNewVenuesToMap(newIds.venues);
    this.addNewVenueGroupsToMap(newIds.groups);
  }


  addNewVenuesToMap(newIds) {

    // Set our current markers list.
    let addedVenueMarkers = _(newIds).map((venueId) => {

      let venue = this.props.venues.venues.find((venue) => { 
        return venue.id == venueId; 
      });

      let marker = new google.maps.Marker({
        position: new google.maps.LatLng(venue.get('latitude'), venue.get('longitude')),
        title:    venue.get('name') + ', ' + venue.get('readable_address'),
        map:      this.map,
      });

      marker.addListener('click', (e) => {
        this.props.handleMarkerClick(marker.venue);
      });

      marker.venue = venue;
      marker.venueId = venue.id;

      return marker;
    });

    // Add our newly created markers to (1) this.markers, and (2) the clusterer.
    _(addedVenueMarkers).each((marker) => {
      this.markers.push(marker);
    });
  }


  addNewVenueGroupsToMap(venueIdArrays) {

    let addedVenueGroupMarkers = [];

    _(venueIdArrays).each((venueIds) => {
      _(venueIds).each((venueId) => {

        let venueGroup = this.props.venues.groups.find((group) => {
          return _(group.ids).contains(venueId);
        });

        let marker = new google.maps.Marker({
          position: new google.maps.LatLng(venueGroup.latitude, venueGroup.longitude),
          map:      this.map
        });

        marker.venueId = venueId;

        addedVenueGroupMarkers.push(marker);
      });
    });

    _(addedVenueGroupMarkers).each((marker) => {
      this.markers.push(marker);
    });

    this.clusterer.addMarkers(this.markers);
  }


  removeAllMarkers() {
    _(this.markers).each((marker) => {
      marker.setMap(null);
    });
    this.markers = [];
    this.clusterer.clearMarkers();
  }


  // Called once onMount, and on events dragend and zoom_changed. 
  // Return center, bounds and zoom values.
  handleMapChange() {
    this.props.handleMapChange({
      center: this.map.getCenter(),
      zoom:   this.map.getZoom(),
      bounds: this.map.getBounds(),
    });
  }


  render() {
    return <div id="map" ref="map"></div>;
  }
}