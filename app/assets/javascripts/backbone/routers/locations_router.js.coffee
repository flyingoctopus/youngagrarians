class Youngagrarians.Routers.LocationsRouter extends Backbone.Router
  initialize: (options) ->
    @locations = new Youngagrarians.Collections.LocationsCollection()
    @locations.reset options.locations

  routes:
    "new"      : "newLocation"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newLocation: ->
    @view = new Youngagrarians.Views.Locations.NewView(collection: @locations)
    $("#locations").html(@view.render().el)

  index: ->
    @view = new Youngagrarians.Views.Locations.IndexView(locations: @locations)
    $("#locations").html(@view.render().el)

  show: (id) ->
    location = @locations.get(id)

    @view = new Youngagrarians.Views.Locations.ShowView(model: location)
    $("#locations").html(@view.render().el)

  edit: (id) ->
    location = @locations.get(id)

    @view = new Youngagrarians.Views.Locations.EditView(model: location)
    $("#locations").html(@view.render().el)
