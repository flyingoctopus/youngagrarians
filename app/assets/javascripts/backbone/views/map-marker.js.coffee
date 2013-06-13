class Youngagrarians.Views.MapMarker extends Backbone.Marionette.ItemView
  template: "backbone/templates/map-marker"

  initialize: () ->
    @marker = null

  createMarker: =>
    if _.isNull @marker
      data = @model.toJSON()
      data.link = @model.locUrl()

      category = @model.get('category').get('name')
      icon = @model.get('category').getIcon()

      @marker = $.goMap.createMarker
        latitude: @model.get 'latitude'
        longitude: @model.get 'longitude'
        id: 'location-' + @model.id
        group: category
        title: @model.get 'name'
        icon: icon

      @model.marker = @marker

      content = JST['backbone/templates/map-marker-bubble'](data)
      contact = JST['backbone/templates/map-marker-bubble-contact'](data)
      share   = JST['backbone/templates/map-marker-bubble-share'](data)

      $.goMap.createListener(
        { type: 'marker', marker: @marker.id },
        'click',
        () ->
          if not _.isUndefined( window.infoBubble ) and not _.isNull( window.infoBubble )
            window.infoBubble.close()

          _infoBub = new InfoBubble
            maxWidth: 600
            arrowStyle: 2

          _infoBub.open $.goMap.getMap(), @

          _infoBub.addTab 'Information', content
          _infoBub.addTab 'Contact', contact
          _infoBub.addTab 'Share', share

          window.infoBubble = _infoBub
      )

    @marker

  getLocation: =>
    { lat: @model.get('latitude'), long: @model.get('longitude') }

  hideMarker: =>
    @marker.setVisible false

  showMarker: =>
    @marker.setVisible true

  onRender: () =>
    @$el.hide();
