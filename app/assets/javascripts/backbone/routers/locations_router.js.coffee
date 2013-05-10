class Youngagrarians.Routers.LocationsRouter extends Backbone.Router

  routes:
    "locations/:id" : "show"

  show: (id) =>
    location = new Backbone.ModelRef window.Locations, id
    location.bindLoadingStates
      loaded: (l) =>
        _.delay @centerMap, 500, l

      unloaded: (l) ->
        console.log 'unloaded'

  centerMap: (loc) =>
    window.Locations.mapUpdate
      type: 'show'
      data: loc
