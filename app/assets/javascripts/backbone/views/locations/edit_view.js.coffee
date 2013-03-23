Youngagrarians.Views.Locations ||= {}

class Youngagrarians.Views.Locations.EditView extends Backbone.View
  template : JST["backbone/templates/locations/edit"]

  events :
    "submit #edit-location" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (location) =>
        @model = location
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
