class Notify extends React.Component {


  constructor(props) {
    super(props);

    this.getCityAndCountryFrom = this.getCityAndCountryFrom.bind(this);
    this.renderComedianAlerts = this.renderComedianAlerts.bind(this);
    this.renderComedianAlertImages = this.renderComedianAlertImages.bind(this);
  }


  componentDidMount() {

    // Fire up the select2 box. I genuinely have no idea why select2() doesn't 
    // work outside setTimeout(), even with delay=0.
    setTimeout(() => {
      $('#comedian_alerts').select2({
        placeholder: "Choose one or more comics to follow",
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
    }, 0);


    $('body').on('click', '.js_destroy-alert', (e) => {
      const alert_id = $(e.target).data('alert-id');
      this.props.handleDestroyAlert(alert_id);
      return false;
    });

  }


  // Receive a Place object, extract its city and country values, and return.
  // Remember, at this point we don't want to get more specific than city-level.
  // Inspecting the place's address_components reveals a big bunch of types:
  // 'country', 'administrative_area_level_2', 'administrative_area_level_1'.
  getCityAndCountryFrom(place) {

    let country = _(place.address_components).find((component) => {
      return _(component.types).contains('country');
    }).long_name;

    let admin_2 = _(place.address_components).find((component) => {
      return _(component.types).contains('administrative_area_level_2');
    }).long_name;

    let admin_1 = _(place.address_components).find((component) => {
      return _(component.types).contains('administrative_area_level_1');
    }).long_name;

    if (admin_1)
      return [admin_2, admin_1, country].join(', ');
    else
      return [admin_2, country].join(', ');
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
          let city_country = this.getCityAndCountryFrom(place);

          $('#google_place_id').val(place.place_id);
          $('#city_country').val(city_country);
          $('#readable_address').val(place.name);

          if (this.marker)
            this.marker.setMap(null);

          this.marker = new google.maps.Marker({
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

      $('#new_alert').on('submit', (e) => {
        $('#autocomplete').val('');

        const data = {};
        $('#new_alert').serializeArray().map((v) => { 
          if (v.name == 'comedian_alerts[]') {
            if (data['comedian_alerts[]'] && data['comedian_alerts[]'].length)
              data['comedian_alerts[]'].push(v.value);
            else
              data['comedian_alerts[]'] = [v.value];
          } else {
            data[v.name] = v.value; 
          }
        });

        this.props.handleCreateAlert(data);

        return false;
      });
    }
  }


  renderComedianAlerts() {
    return (
      this.props.alerts.map((alert) => 
        <li key={alert.id}>
          {alert.get('city_country')}
          <a href="#" data-alert-id={alert.id} className="js_edit-alert">Edit</a>
          <a href="#" data-alert-id={alert.id} className="js_destroy-alert">Destroy</a>
          {alert.comedian_alerts().length ? 
            <ul>{this.renderComedianAlertImages(alert.comedian_alerts())}</ul>
            :
            ''
          }
        </li>
      )
    )
  }


  renderComedianAlertImages(comedian_alerts) {
    return (
      comedian_alerts.map((comedian_alert) => 
        <li key={comedian_alert.id}>
          <img src={comedian_alert.comedian().get('mugshot_url')} width="40" height="40" />
        </li>
      )
    )
  }



  render() {
    const newAlert = true;//this.state.newAlert;

    return (
      <div>
        {this.props.user ? (
          <div>
            <button className="btn btn-primary">New alert</button>

            <form style={{display: newAlert}} className="form-inline" id="new_alert" data-remote="true" method="post" action="">
              <select 
                name="comedian_alerts[]"
                id="comedian_alerts"
                className="form-control"
                multiple="multiple"
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

              <input className="form-control" type="text" id="autocomplete" placeholder="Type a city here" />
              <input type="hidden" name="google_place_id" value="" id="google_place_id" />
              <input type="hidden" name="city_country" id="city_country" value="" />
              <input type="hidden" name="readable_address" id="readable_address" value="" />
              <input type="submit" className="btn btn-primary" value="Stay Sharp" />
            </form>

            <div className="panel panel-default">
              <div className="panel-heading">
                <h4 className="panel-title">Your alerts</h4>
              </div>
              <div className="panel-body">
                {this.props.alerts.length ? 
                  <ul>{this.renderComedianAlerts()}</ul>
                  :
                  <span>Set up a new alert above.</span>
                }
              </div>
            </div>
          </div>
        ) : (
          <span>Log in to set up alerts for comedians A-Y visiting city Z.</span>
        )}
      </div>
    );
  }
}


