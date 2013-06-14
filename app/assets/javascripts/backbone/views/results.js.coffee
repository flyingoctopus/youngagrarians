class Youngagrarians.Views.Results extends Backbone.Marionette.CompositeView
  template: "backbone/templates/results"
  tagName: "div"
  className: "results-container"
  itemView: Youngagrarians.Views.ResultItem
  itemViewContainer: "ul#results-list"
