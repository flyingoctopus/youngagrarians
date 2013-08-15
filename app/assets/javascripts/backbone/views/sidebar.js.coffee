class Youngagrarians.Views.Sidebar extends Backbone.Marionette.Layout
  template: "backbone/templates/sidebar"
  itemView: Youngagrarians.Views.SidebarItem

  regions:
    provinces: "#map-provinces"
    bioregions: "#map-bioregions"
    categories: "#map-category"
    legend: "#map-legend-container"
    search: "#map-search"
    extras: "#extras"

  events:
    "click a.hide-show": "toggleLegend"

  initialize: (options) ->
    @app = options.app
    @provincesView = new Youngagrarians.Views.Provinces app: @app
    @bioregionsView = new Youngagrarians.Views.Bioregions app: @app
    @categoriesView = new Youngagrarians.Views.Categories app: @app, collection: @collection
    @legendView = new Youngagrarians.Views.Legend app: @app, collection: @collection
    @searchView = new Youngagrarians.Views.Search app: @app
    @extrasView = new Youngagrarians.Views.Extras app: @app

  onRender: =>
    @.provinces.show @provincesView
    @.bioregions.show @bioregionsView
    @.categories.show @categoriesView
    @.legend.show @legendView
    @.search.show @searchView
    @.extras.show @extrasView

  toggleLegend: (e) =>
    e.preventDefault()

    currentlyShown = !!$(e.target).data('legend-shown')

    if currentlyShown
      $(e.target).data('legend-shown', 0).text("Show")
      $( @legendView.el ).hide()
    else
      $(e.target).data('legend-shown', 1).text("Hide")
      $( @legendView.el ).show()
