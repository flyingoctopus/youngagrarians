class Youngagrarians.Views.MapMarker extends Backbone.Marionette.ItemView
  template: "backbone/templates/map-marker"

  initialize: () ->
    @marker = null
    @model.on 'change:show', @showHideMarker, @

  showHideMarker: (data) =>
    console.log "mapMarker view, showHideMarker: ", data

  createMarker: =>
    @marker = $.goMap.createMarker
      latitude: @model.get 'latitude'
      longitude: @model.get 'longitude'
      id: @model.get '_id'
      group: @model.get 'type'
      title: @model.get 'name'
      html: @model.get 'content'
      icon: "http://www.google.com/intl/en_ALL/mapfiles/marker_greenA.png"

  onRender: () =>
    @$el.hide();
