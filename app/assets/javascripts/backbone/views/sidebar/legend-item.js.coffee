class Youngagrarians.Views.LegendItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/legend-item"
  tagName: "li"

  serializeData: =>
    data = @model.toJSON()
    data.img = @model.getIcon()
    data
