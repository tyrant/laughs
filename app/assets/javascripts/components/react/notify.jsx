class Notify extends React.Component {


  constructor() {
    super();
  }


  // Wee state problem - the map object doesn't get set until the <Map />
  // gets mounted and calls handleMapCreated(), by which time this <Notify />
  // will have already been mounted, minus its vital map object. Solution:
  // have this conditional inside componentDidUpdate() which sets the autocomplete,
  // exactly once.
  componentDidUpdate() {
    if (this.props.map && !this.autocomplete) {

      let input = document.getElementById('autocomplete');
      this.autocomplete = new google.maps.places.Autocomplete(input);
      this.autocomplete.bindTo('bounds', this.props.map);

      this.autocomplete.addListener('place_changed', () => {
        let place = this.autocomplete.getPlace();

        if (place.geometry) {
          let location = place.geometry.location;
          $('#place_id').val(place.place_id);

          let marker = new google.maps.Marker({
            map:       this.props.map,
            position:  location,
            icon:      '/blue-marker.png',
            animation: google.maps.Animation.DROP,
          });

          if (!this.props.map.getBounds().contains(location)) {
            this.props.map.setCenter(place.geometry.location);
          }
        }
      });

      $('#autocomplete_form').on('submit', (e) => {
        e.preventDefault();
      });
    }
  }


  render() {
    return (
      <div>
        <input className="form-control" type="text" id="autocomplete" placeholder="Ratchet that shit" />
        <form className="form-inline" id="autocomplete_form" data-remote="true" method="post" action="">
          <input type="hidden" name="place_id" value="" id="place_id" />

          <input className="form-control" type="email" id="email" name="email" />
          <input type="submit" className="btn btn-primary" value="Fire" />
        </form>
      </div>
    );
  }
}


