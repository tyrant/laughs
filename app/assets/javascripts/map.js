var app = {};

app.map = function() {


  // Fire up the map.
  var defaultLat = $.query.get('lat') || 49;
  var defaultLng = $.query.get('lng') || 3;
  var defaultZoom = $.query.get('zoom') || 5;
  window.map = new google.maps.Map(document.getElementById('map'), {
    center: new google.maps.LatLng(defaultLat, defaultLng),
    zoom:   defaultZoom
  });


  // Whenever we drag or zoom the map, call mapChanged() to update the querystring with the new data.
  window.map.addListener('dragend', app.mapChanged);
  window.map.addListener('zoom_changed', app.mapChanged);


  // Fire up select2 and datepickers.
  $('#comedians').select2({
    placeholder: 'Find gigs performed by ...'
  });
  $('#start_date').datetimepicker({
    format:      'DD/MM/YYYY',
    defaultDate: moment() // Start date: right now.
  });
  $('#end_date').datetimepicker({ 
    format:      'DD/MM/YYYY',
    defaultDate: moment().add(1, 'year') // End date: a year from now.
  });


  // Altering any form input triggers a submit.
  $('#start_date, #end_date').on('dp.change', function() { $('#filter').submit(); });
  $('#comedians').on('change', function() { $('#filter').submit(); });


  // Whenever we or the user submits the filter-form, append its data to the existing lot.
  $('#filter').on('submit', function() {
    var data = $(this).serialize();

  });


  // Fire off our form to get the first dataset.  
  $('#filter').submit();


  // Handle toggling the overlay.
  $('#toggle_overlay').on('click', function() { 
    $('#overlay').toggle(); 
  });
}


// Whenever the dragend or zoom_changed map events fire, call this.
app.mapChanged = function() {
  var c = window.map.getCenter();
  var z = window.map.getZoom();
  window.history.pushState([c.lat(), c.lng(), z], 'Changed the map', '/?lat=' + c.lat() + '&lng=' + c.lng() + '&zoom=' + z);
};

// The shit in the URL is really piling up!
// Current suspects: lat, lng, zoom, comedians[], start_date, end_date.
app.getVarsChanged = function() {

}
