class Youngagrarians.Routers.LocationsRouter extends Backbone.Router

  routes:
    "location/:id" : "show"

  show: (id) ->
    _.delay @showLocation, 200, id

  showLocation: (id) ->
    location = window.Locations.get id
    console.log 'got location: ', location
    $.goMap.setMap
      latitude: location.lat()
      longitude: location.lng()
      zoom: 16
