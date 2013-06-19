class Youngagrarians.Views.MapMarker extends Backbone.Marionette.ItemView
  template: "backbone/templates/map-marker"

  initialize: () ->
    @marker = null

  createMarker: =>
    if _.isNull @marker
      data = @model.toJSON()
      data.link = encodeURIComponent @model.locUrl()

      category = @model.get('category').get('name')
      icon = @model.get('category').getIcon()

      data.category_name = category
      data.category_icon = icon

      subcategories = @model.get('subcategory').pluck('name').join(' , ')
      data.subcategories = subcategories

      lat = @model.get 'latitude'
      long = @model.get 'longitude'

      if !_.isUndefined( lat ) and !_.isNull( lat ) and !_.isUndefined( long ) and !_.isNull( long )
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
              maxWidth: 830
              maxHeight: 300
              arrowStyle: 2
              content: content
              backgroundClassName: 'map-bubble-background'
              borderRadius: 0

            _infoBub.open $.goMap.getMap(), @

            func = () =>
              if !_.isUndefined window.twttr
                twttr.widgets.createShareButton(
                  window.location.origin + _model.locUrl(),
                  $("#map-popup-"+_model.id+" .share .twitter")[0],
                  (el) =>
                  { text: _model.get('name'), via: 'youngagrarians' }
                )

              facebookLink = $("#map-popup-"+_model.id+" .share .facebook a")

              link = "https://www.facebook.com/dialog/feed?" +
                "app_id=542090742493894&" +
                "link="+_model.locUrl()+"&" +
                "picture="+window.location.origin+"/~youngagr/assets/map/ya.jpg&" +
                "name="+ _model.get('name')+"&" +
                "caption=Location On YoungAgrarians.ca Map&" +
                "description="+_model.get("description")+"&" +
                "redirect_uri=" + _model.locUrl()

              facebookLink.attr 'href', link

            _.delay func, 200
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
