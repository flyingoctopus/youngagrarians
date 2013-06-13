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

  window.Categories.fetch
    reset: true

  window.Locations.fetch
    reset: true

YA.addInitializer (options) ->
  router = new Youngagrarians.Routers.LocationsRouter()
  Backbone.history.start()

YA.addInitializer (options) ->
  sidebar = new Youngagrarians.Views.Sidebar collection: Categories, app: @
  @.sidebar.show sidebar
  map = new Youngagrarians.Views.Map collection: Locations, app: @
  @.map.show map
  results = new Youngagrarians.Views.Results collection: Locations, map: map, app: @
  @.results.show results

  sidebar.on 'filter', map.filter


###
# D.addInitializer (options) ->
  @vent.on 'user:login', () =>
    @headerView.updateHeader()
    @navView.navVisible()

  @vent.on 'user:logout', () =>
    @headerView.updateHeader()
    @navView.navVisible()

  @vent.on 'nav', (e) =>
    @navView.section e
    @headerView.section e

D.addInitializer (options) ->
  @vent.trigger 'nav', Backbone.history.fragment
###