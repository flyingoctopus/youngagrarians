#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

@Youngagrarians =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

@YA = new Backbone.Marionette.Application()

YA.addRegions
  map: "#map"
  sidebar: "#sidebar"
  results: "#results"

YA.addInitializer (options) ->
  window.Locations = new Youngagrarians.Collections.LocationsCollection()
  window.Categories = new Youngagrarians.Collections.CategoriesCollection()
  window.Subcategories = new Youngagrarians.Collections.SubcategoryCollection()

  window.Categories.fetch
    reset: true

  window.Locations.fetch
    reset: true

  window.Subcategories.fetch
    reset: true

YA.addInitializer (options) ->
  router = new Youngagrarians.Routers.LocationsRouter()
  Backbone.history.start()

YA.addInitializer (options) ->
  @sidebarView = new Youngagrarians.Views.Sidebar collection: Categories, app: @
  @.sidebar.show @sidebarView
  @mapView = new Youngagrarians.Views.Map collection: Locations, app: @
  @.map.show @mapView
  @resultsView = new Youngagrarians.Views.Results collection: Locations, map: map, app: @
  @.results.show @resultsView
