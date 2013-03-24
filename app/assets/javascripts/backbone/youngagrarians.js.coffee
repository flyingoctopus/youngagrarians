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
  map: "#map-container"
  categories: "#category-list"
  results: "#results"

YA.addInitializer (options) ->
  window.Locations = new Youngagrarians.Collections.LocationsCollection()
  window.Locations.fetch
    reset: true

YA.addInitializer (options) ->
  sidebar = new Youngagrarians.Views.Sidebar locations: Locations
  @.categories.show sidebar
  map = new Youngagrarians.Views.Map collection: Locations
  @.map.show map
  results = new Youngagrarians.Views.Results collection: Locations
  @.results.show results

  sidebar.on 'filter', map.filter