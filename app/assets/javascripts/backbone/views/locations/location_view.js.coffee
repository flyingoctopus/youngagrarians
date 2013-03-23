Youngagrarians.Views.Locations ||= {}

class Youngagrarians.Views.Locations.LocationView extends Backbone.View
  template: JST["backbone/templates/locations/location"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
