class Youngagrarians.Views.MapMarker extends Backbone.Marionette.ItemView
  template: "backbone/templates/map-marker"

  initialize: () ->
    @marker = null

  createMarker: =>
    @marker = $.goMap.createMarker
      latitude: @model.get 'latitude'
      longitude: @model.get 'longitude'
      id: @model.get '_id'
      group: @model.get('category').get('name')
      title: @model.get 'name'
      html: @model.get 'content'
      icon: "http://www.google.com/intl/en_ALL/mapfiles/marker_greenA.png"

  onRender: () =>
    @$el.hide();
