class Youngagrarians.Models.Location extends Backbone.Model
  paramRoot: 'location'

  defaults:
    latitude: null
    longitude: null
    gmaps: null
    address: null
    name: null
    content: null
    type: null

class Youngagrarians.Collections.LocationsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  url: '/locations'

  initialize: (options) ->
    @on 'map:update', @mapUpdate

  mapUpdate: (data) =>
    console.log 'updating location modles in collection, data: ', data


  # move these somewhere else, like the view
  # the collection doesn't care about which ones are visible in the map
  # just the results list
  getMapBounds: () =>
    bounds = $.goMap.getBounds()
    console.log 'map center: ', $.goMap.map.getCenter()
    console.log 'southwest ( bottom right ): ', bounds.getSouthWest()
    console.log 'northeast ( top left ): ', bounds.getNorthEast()

  filterType: (type) =>
    console.log 'filtering type to hidden'