#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Youngagrarians =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

window.YA = new Backbone.Marionette.Application()

YA.addInitializer (options) ->
  $("#map").goMap
    latitude: 54.826008
    longitude: -125.200195
    zoom: 5
    maptype: 'ROADMAP'