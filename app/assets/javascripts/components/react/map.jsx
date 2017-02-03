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