class Youngagrarians.Routers.LocationsRouter extends Backbone.Router

  routes:
    "location/:id" : "show"

  show: (id) ->
    _.delay @showLocation, 400, id

  showLocation: (id) ->
    location = window.Locations.get id
    $.goMap.setMap
      latitude: location.lat()
      longitude: location.lng()
      zoom: 16
    window.Locations.trigger 'map:update', {}
