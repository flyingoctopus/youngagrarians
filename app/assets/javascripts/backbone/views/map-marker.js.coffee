class Youngagrarians.Views.MapMarker extends Backbone.Marionette.ItemView
  template: "backbone/templates/map-marker"

  initialize: () ->
    @marker = null

  createMarker: =>
    data = @model.toJSON()
    data.link = @model.locUrl()

    @marker = $.goMap.createMarker
      latitude: @model.get 'latitude'
      longitude: @model.get 'longitude'
      id: 'location-' + @model.get('id')
      group: @model.get('category').get('name')
      title: @model.get 'name'
      html: JST['backbone/templates/map-marker-bubble'](data)
      icon: "http://www.google.com/intl/en_ALL/mapfiles/marker_greenA.png"
    @model.marker = @marker
    @marker

  getLocation: =>
    { lat: @model.get('latitude'), long: @model.get('longitude') }

  hideMarker: =>
    @marker.setVisible false

  showMarker: =>
    @marker.setVisible true

  onRender: () =>
    @$el.hide();
