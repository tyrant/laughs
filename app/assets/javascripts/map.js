var app = {};

app.map = function() {


  // Fire up the map. Ask the user for their location, and centre the map on it.
  // Latlng hierarchy: go with url lat/lng, then geolocation, then default.

  // window.navigator.geolocation.getCurrentPosition(function(position) {

  // }, function() {

  // });

  var uriData = new URI(window.location.search).search(true);

  var lat = (uriData.lat && uriData.lat != 'undefined') ? parseFloat(uriData.lat) : 49;
  var lng = (uriData.lng && uriData.lng != 'undefined') ? parseFloat(uriData.lng) : 3;
  var zoom = (uriData.zoom && uriData.zoom != 'undefined') ? parseFloat(uriData.zoom) : 5;
  window.map = new google.maps.Map(document.getElementById('map'), {
    center: new google.maps.LatLng(lat, lng),
    zoom:   zoom
  });


  // Whenever we alter the map or the search form, update the querystring with the new data.
  window.map.addListener('dragend', app.stateChanged);
  window.map.addListener('zoom_changed', app.stateChanged);
  $('#filter').on('submit', app.stateChanged);


  // Fire up select2 and datepickers.
  // Comedian list: either those listed in the querystring, or defaults to all.
  $('#comedians').select2({
    placeholder: 'Find comedy gigs performed by ...'
  });

  // Start date: either that in the querystring, or right now.
  var start = (uriData.start_date && uriData.start_date != 'undefined') ? moment(uriData.start_date) : moment()
  $('#start_date').datetimepicker({
    format:      'DD MMM YYYY',
    defaultDate: start
  });

  // End date: either that in the querystring, or one year from now.
  var end = (uriData.end_date && uriData.end_date != 'undefined') ? moment(uriData.end_date) : moment().add(1, 'year');
  $('#end_date').datetimepicker({ 
    format:      'DD MMM YYYY',
    defaultDate: end
  });


  // Altering any form input triggers a submit.
  $('#start_date, #end_date').on('dp.change', function() { $('#filter').submit(); });
  $('#comedians').on('change', function() { $('#filter').submit(); });


  // Handle toggling the overlay.
  $('#toggle_overlay').on('click', function() { 
    $('#overlay').toggle(); 
  });


  // And finally, fire off our newly filled-in form to get our first dataset.  
  $('#filter').submit();
}

// The shit in the URL is really piling up!
// Current suspects: lat, lng, zoom, comedians[], start_date, end_date.
// If any of these change, update the URL.
app.stateChanged = function() {

  // Map data:
  var c = window.map.getCenter();
  var z = window.map.getZoom();

  var uri = new URI(window.location.host + '?' + $('#filter').serialize() + '&lat=' + c.lat() + '&lng=' + c.lng() + '&zoom=' + z);

  window.history.pushState(uri.search(true), 'Changed app state', '?' + uri.query());
}
