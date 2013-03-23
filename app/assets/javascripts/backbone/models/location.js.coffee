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
