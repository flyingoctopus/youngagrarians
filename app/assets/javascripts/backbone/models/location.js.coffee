class Youngagrarians.Models.Location extends Backbone.RelationalModel
  paramRoot: 'location'
  url: '/locations'

  relations: [
    type: 'HasOne'
    key: 'category'
    relatedModel: 'Youngagrarians.Models.Category'
    includeInJSON: Backbone.Model.prototype.idAttribute,
    collectionType: 'Youngagrarians.Collections.CategoriesCollection'
    reverseRelation:
      key: 'location'
      includeInJSON: '_id'
  ]

  defaults:
    latitude: null
    longitude: null
    gmaps: null
    address: null
    name: null
    content: null
    markerVisible: true

  lat: =>
    return @get 'latitude'

  lng: =>
    return @get 'longitude'

Youngagrarians.Models.Location.setup()

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
        if _(data).indexOf( m.get('category').get('name') ) >= 0
          $.goMap.showHideMarker m.id, true
          m.set 'markerVisible', true
        else
          $.goMap.showHideMarker m.id, false
          m.set 'markerVisible', false
      else
        m.set 'markerVisible', $.goMap.isVisible m
    true