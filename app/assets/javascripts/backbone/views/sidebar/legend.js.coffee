#= require ./legend-item
class Youngagrarians.Views.Legend extends Backbone.Marionette.CollectionView
  tagName: "ul"
  className: "unstyled"

  itemView: Youngagrarians.Views.LegendItem

  buildItemView: (item, view, options) =>
    options = _.extend { app: @app, model: item }, options
    new view options

  initialize: (options) =>
    @app = options.app
