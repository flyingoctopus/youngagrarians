#= require ./legend-item
class Youngagrarians.Views.Legend extends Backbone.Marionette.CollectionView
  tagName: "ul"
  className: "unstyled"

  itemView: Youngagrarians.Views.LegendItem

  onRender: =>
    console.log 'legend rendered: ', @$el, @el