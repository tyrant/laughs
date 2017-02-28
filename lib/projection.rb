# Lovingly stolen from github.com/clarketus/findmyflat/blob/master/lib/projection.rb and refactored to my tastes.

module Projection 

  TILE_SIZE = 256.0

  # Google maps earth radius in metres
  RADIUS = 6378137.0

  # 2*pi*r / tiles = the width in metres of a tile at the equator, and all tile heights
  INITIAL_RESOLUTION = 2.0 * Math::PI * RADIUS / TILE_SIZE

  # Halfway round the world.
  ORIGIN_SHIFT = Math::PI * RADIUS


  def Projection.latlng_to_pixels(lat, lng, zoom)
    lat = lat.to_f
    lng = lng.to_f
    zoom = zoom.to_i
    mx, my = Projection.latlng_to_metres(lat, lng)
    Projection.metres_to_pixels(mx, my, zoom)
  end


  def Projection.pixels_to_latlng(px, py, zoom)
    px = px.to_i
    py = py.to_i
    zoom = zoom.to_i
    mx, my = Projection.pixels_to_metres(px, py, zoom)
    trim(*Projection.metres_to_latlng(mx, my))
  end


  def Projection.trim(lat, lng)
    lng = lng + 360 if lng < -180
    lng = lng - 360 if lng > 180

    lat = -90 if lat < -90
    lat = 90 if lat > 90

    [lat, lng]
  end


  private


  def Projection.latlng_to_metres(lat, lng)
    mx = lng * ORIGIN_SHIFT / 180.0
    my = Math::log(Math::tan((90 + lat) * Math::PI / 360)) / (Math::PI / 180)

    my = my * ORIGIN_SHIFT / 180

    [mx, my]
  end


  def Projection.metres_to_pixels(mx, my, zoom)
    res = Projection.resolution(zoom)
    px = (mx + ORIGIN_SHIFT) / res
    py = (my + ORIGIN_SHIFT) / res

    [px, py]
  end


  def Projection.pixels_to_metres(px, py, zoom)
    res = Projection.resolution(zoom)
    mx = px.to_f * res - ORIGIN_SHIFT
    my = py.to_f * res - ORIGIN_SHIFT

    [mx, my]
  end


  def Projection.metres_to_latlng(mx, my)
    lng = (mx / ORIGIN_SHIFT) * 180
    lat = (my / ORIGIN_SHIFT) * 180

    lat = 180 / Math::PI * (2.0 * Math::atan(Math::exp(lat * Math::PI / 180)) - Math::PI / 2)

    [lat, lng]
  end


  def Projection.resolution(zoom)
    INITIAL_RESOLUTION / (2**zoom)
  end
end