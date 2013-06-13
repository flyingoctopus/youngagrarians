class Youngagrarians.Views.Sidebar extends Backbone.Marionette.Layout
  template: "backbone/templates/sidebar"
  itemView: Youngagrarians.Views.SidebarItem

  regions:
    provinces: "#map-provinces"
    bioregions: "#map-bioregions"
    categories: "#map-category"
    legend: "#map-legend-container"
    search: "#map-search"

  initialize: (options) ->
    @app = options.app
    @provincesView = new Youngagrarians.Views.Provinces app: @app
    @bioregionsView = new Youngagrarians.Views.Bioregions app: @app
    @categoriesView = new Youngagrarians.Views.Categories app: @app, collection: @collection
    @legendView = new Youngagrarians.Views.Legend app: @app, collection: @collection

  onRender: =>
    @.provinces.show @provincesView
    @.bioregions.show @bioregionsView
    @.categories.show @categoriesView
    @.legend.show @legendView
