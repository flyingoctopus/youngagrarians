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

      _model = @model
      _this = @
      $.goMap.createListener(
        { type: 'marker', marker: @marker.id },
        'click',
        () ->
          if not _.isUndefined( window.infoBubble ) and not _.isNull( window.infoBubble )
            window.infoBubble.close()

          _infoBub = new InfoBubble
            maxWidth: 500
            maxHeight: 300
            arrowStyle: 2
            content: content
            backgroundClassName: 'map-bubble-background'
            borderRadius: 0

          _infoBub.open $.goMap.getMap(), @

          console.log 'window.twttr: ', window.twttr
          if !_.isUndefined window.twttr
            console.log 'window.twittr defined!', window.location.origin + _model.locUrl(),_model.locUrl()
            func = (el) ->
              console.log 'created share button', el

            #twttr.widgets.createShareButton( "http://seanhagen.ca" , $("#map-popup-3 .share .twitter")[0], function(el){},{ text: "testing this out", via: 'youngagrarians' })

            twttr.widgets.createShareButton(
              window.location.origin + _model.locUrl(),
              _this.$el.find(".twitter")[0],
              func,
              { text: _model.get('name'), via: 'youngagrarians' }
            )

          window.infoBubble = _infoBub
      )
    @marker.setVisible false
    @marker

  getLocation: =>
    { lat: @model.get('latitude'), long: @model.get('longitude') }

  hideMarker: =>
    @marker.setVisible false

  showMarker: =>
    @marker.setVisible true

  onRender: () =>
    @$el.hide();
