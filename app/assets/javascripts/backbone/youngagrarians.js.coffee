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
  main: "#application"
  categories: "#category-list"

YA.addInitializer (options) ->
  window.Locations = new Youngagrarians.Collections.LocationsCollection()
  window.Locations.fetch
    reset: true

YA.addInitializer (options) ->
  @.categories.show new Youngagrarians.Views.Sidebar locations: Locations
  @.main.show new Youngagrarians.Views.ApplicationLayout

YA.addInitializer (options) ->
  $("#map").goMap
    latitude: 54.826008
    longitude: -125.200195
    zoom: 5
    maptype: 'ROADMAP'

  $.goMap.createListener(
    {type:'map'}
    'zoom_changed'
    (event) ->
      window.Locations.trigger 'map:update', 'zoom_changed'
  )

  $.goMap.createListener(
    {type: 'map'}
    'dragend'
    (event) ->
      window.Locations.trigger 'map:update', 'dragend'
  )
