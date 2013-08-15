class Youngagrarians.Views.Results extends Backbone.Marionette.CompositeView
  template: "backbone/templates/results"
  tagName: "div"
  className: "results-container"
  itemView: Youngagrarians.Views.ResultItem
  itemViewContainer: "ul#results-list"

  buildItemView: (item, view, options) =>
    options = _.extend { app: @app, model: item }, options
    new view options

  initialize: (options) =>
    @app = options.app
