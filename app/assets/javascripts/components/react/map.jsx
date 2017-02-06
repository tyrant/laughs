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

    // Fire up the clusterer.
    this.clusterer = new MarkerClusterer(this.map, [], {
      imagePath: '/m'
    });

    // Fire up a few event listeners.
    this.map.addListener('dragend', this.handleMapChange);
    this.map.addListener('zoom_changed', this.handleMapChange); 

    // And fire map change just once. 
    google.maps.event.addListenerOnce(this.map, 'idle', () => {
      this.handleMapChange();
    });
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

    // Set our current markers list.
    let addedMarkers = _(venueIds).map((venueId) => {

      let venue = this.props.selectedVenuesAndGigs.find((venue) => { 
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
      return marker;
    });

    // Add our newly created markers to (1) this.markers, and (2) the clusterer.
    _(addedMarkers).each((marker) => {
      this.markers.push(marker);
    });
    this.clusterer.addMarkers(this.markers);
  }


  removeOldVenuesFromMap(venueIds) {

    // Calculate which markers are to be removed
    var removedMarkers = _(venueIds).map((venueId) => {
      return _(this.markers).find((marker) => { 
        return marker.venue.id == venueId; 
      });
    });

    // Remove them from this.markers
    this.markers = _(this.markers).filter((marker) => {
      return !_(venueIds).contains(marker.venue.id);
    });

    // Set their map to null
    _(removedMarkers).each((marker) => {
      marker.setMap(null);
    });

    // Remove markers from clusterer. Testing shows this is much much faster
    // than calling this.clusterer.removeMarker() on each removed marker.
    this.clusterer.clearMarkers();
    this.clusterer.addMarkers(this.markers);
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