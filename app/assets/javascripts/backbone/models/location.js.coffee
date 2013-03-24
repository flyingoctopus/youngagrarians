class Youngagrarians.Models.Location extends Backbone.Model
  paramRoot: 'location'
  idAttribute: '_id'

  defaults:
    latitude: null
    longitude: null
    gmaps: null
    address: null
    name: null
    content: null
    type: null
    markerVisible: true

  lat: =>
    return @get 'latitude'

  lng: =>
    return @get 'longitude'

class Youngagrarians.Collections.LocationsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  url: '/locations'

  initialize: (options) ->
    @on 'map:update', @mapUpdate, @

  mapUpdate: (data) =>
    ids = $.goMap.markers
    markers = $.goMap.getMarkers()

    _(markers).each (latlng,i) =>
      id = ids[i]
      m = @get id
      m.set 'markerVisible', $.goMap.isVisible m

    true