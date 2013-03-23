Youngagrarians.Views.Locations ||= {}

class Youngagrarians.Views.Locations.ShowView extends Backbone.View
  template: JST["backbone/templates/locations/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
