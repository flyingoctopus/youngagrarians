Youngagrarians.Views.Locations ||= {}

class Youngagrarians.Views.Locations.IndexView extends Backbone.View
  template: JST["backbone/templates/locations/index"]

  initialize: () ->
    @options.locations.bind('reset', @addAll)

  addAll: () =>
    @options.locations.each(@addOne)

  addOne: (location) =>
    view = new Youngagrarians.Views.Locations.LocationView({model : location})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(locations: @options.locations.toJSON() ))
    @addAll()

    return this
