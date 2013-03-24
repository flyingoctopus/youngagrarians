class Youngagrarians.Views.Map extends Backbone.Marionette.CompositeView
  template: "backbone/templates/map"
  itemView: Youngagrarians.Views.MapMarker
  map: null

  onRender: () =>
    @map = $("#map").goMap
      latitude: 54.826008
      longitude: -125.200195
      zoom: 5
      maptype: 'ROADMAP'

    $.goMap.createListener(
      {type:'map'}
      'zoom_changed'
      (event) =>
        @collection.trigger 'map:update', {type: 'zoom', data: event}
    )

    $.goMap.createListener(
      {type: 'map'}
      'dragend'
      (event) =>
        @collection.trigger 'map:update', {type: 'dragend', data: event}
    )

    if @collection.length
      _(@children).each (child) ->
        child.createMarker()
      $.goMap.fitBounds 'visible'

  filter: (data) =>
    console.log 'got filter event: ', data
    _($.goMap.markers).each (marker) ->
      $.goMap.showHideMarker marker, true

    _(data).each (d) ->
      $.goMap.showHideMarkerByGroup d, false

    $.goMap.fitBounds 'visible'

  # move these somewhere else, like the view
  # the collection doesn't care about which ones are visible in the map
  # just the results list
  getMapBounds: () =>
    bounds = $.goMap.getBounds()
    console.log 'map center: ', $.goMap.map.getCenter()
    console.log 'southwest ( bottom right ): ', bounds.getSouthWest()
    console.log 'northeast ( top left ): ', bounds.getNorthEast()

  filterType: (type) =>
    console.log 'filtering type to hidden'