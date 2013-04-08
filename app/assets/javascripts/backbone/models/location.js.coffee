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
    data = data.data
    ids = $.goMap.markers
    markers = $.goMap.getMarkers()
    _(markers).each (latlng,i) =>
      id = ids[i]
      m = @get id
      if !_.isUndefined data
        if data.length == 0 or _(data).indexOf( m.get('type') ) >= 0
          console.log 'showing marker: ', m.get('name')
          $.goMap.showHideMarker m.id, true
          m.set 'markerVisible', true
        else
          console.log 'hiding marker: ', m.get('name')
          $.goMap.showHideMarker m.id, false
          m.set 'markerVisible', false
      else
        m.set 'markerVisible', $.goMap.isVisible m
    true