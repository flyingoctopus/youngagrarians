class Youngagrarians.Views.Map extends Backbone.Marionette.CompositeView
  template: "backbone/templates/map"
  itemView: Youngagrarians.Views.MapMarker
  map: null

  events:
    'click a#add-to-map' : 'addLocation'
    'click a#show-about' : 'showAbout'
    'click button#go-search' : 'doSearchProvince'
    'submit form#map-search-form' : 'doSearch'
    'click a#map-search-clear' : 'clearSearch'
    'click li.province' : 'changeProvince'

  collectionEvents:
    'reset' : 'addMarkers'
    'add'   : 'addMarker'

  initialize: (options) =>
    window.onresize = @resizeMap

  resizeMap: (e) =>
    console.log 'need to resize map'

  addMarkers: (col) =>
    _.defer =>
      @children.each ( child ) =>
        marker = child.createMarker()

  addMarker: (model) =>
    @addMarkers model.collection

  showAbout: (e) =>
    e.preventDefault()
    about = new Youngagrarians.Views.About
    about.render()

  addLocation: (e) =>
    e.preventDefault()
    newLocation = new Youngagrarians.Models.Location
    addLoc = new Youngagrarians.Views.AddLocation model: newLocation
    addLoc.render()

  changeProvince: (e) =>
    province = $(e.target).text()
    $("button#go-search").data('province', province).text province

  clearSearch: (e) =>
    e.preventDefault()
    @collection.clearShow()

  searchSuccess: (data,status,xhr) =>
    ids = _(data).pluck 'id'
    locations = _(ids).map (id) ->
      'location-'+id

    showLocations = () =>
      $.goMap.fitBounds('markers', locations )
      if ( locations.length <= 1 )
         $.goMap.setMap
          zoom: 10
      @collection.setShow ids

    _.delay showLocations, 100

  doSearch: (e) =>
    e.preventDefault()
    terms = $("#map-search-terms").val()

    $.ajax
      type: "POST"
      url: "/~youngagr/search"
      data:
        terms: terms
      success: @searchSuccess

  doSearchProvince: (e) =>
    e.preventDefault()
    terms = $("#map-search-terms").val()
    province = $(e.target).data('province')

    $.ajax
      type: "POST"
      url: "/~youngagr/search"
      data:
        terms: terms
        province: province
      success: @searchSuccess

  onShow: () =>
    @show = []
    @map = $("#map").goMap
      latitude: 54.826008
      longitude: -125.200195
      zoom: 5
      maptype: 'ROADMAP'
      scrollwheel: false

    center = $("#go-search").data('province') + ", Canada"
    $.goMap.setMap
      address: center
      zoom: 5

    $.goMap.createListener(
      'map'
      'zoom_changed'
      (event) =>
        @collection.trigger 'map:update', {type: 'zoom', data: event}
        true
    )

    $.goMap.createListener(
      'map'
      'dragend'
      (event) =>
        @collection.trigger 'map:update', {type: 'dragend', data: event}
        true
    )

    if @collection.length
      _(@children).each (child) ->
        child.createMarker()

  filter: (data) =>
    @collection.trigger 'map:update', {type: 'filter', data: data}
