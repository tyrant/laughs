$(function() {

  // Fire up the map.
  window.map = new google.maps.Map(document.getElementById('map'), {
    center: new google.maps.LatLng(54, -5),
    zoom:   5
  });

  // Fire up select2 and datepickers.
  $('#comedians').select2();
  $('#start_date').datetimepicker({
    format:      'DD/MM/YYYY',
    defaultDate: moment() // Start date: right now.
  });
  $('#end_date').datetimepicker({ 
    format:      'DD/MM/YYYY',
    defaultDate: moment().add(1, 'year') // End date: a year from now.
  });

  $('#filter').submit();
});
