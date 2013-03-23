Youngagrarians.Views.Locations ||= {}

class Youngagrarians.Views.Locations.NewView extends Backbone.View
  template: JST["backbone/templates/locations/new"]

  events:
    "submit #new-location": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (location) =>
        @model = location
        window.location.hash = "/#{@model.id}"

      error: (location, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
