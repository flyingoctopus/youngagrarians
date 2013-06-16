class Youngagrarians.Views.LegendItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/legend-item"
  tagName: "li"

  events:
    "click a": "selectCat"

  initialize: (options) =>
    @app = options.app

  serializeData: =>
    data = @model.toJSON()
    data.img = @model.getIcon()
    data

  selectCat: (e) =>
    e.preventDefault()
    @app.vent.trigger "legend:clicked", @model.get("id")
