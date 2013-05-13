class Youngagrarians.Views.Map extends Backbone.Marionette.CompositeView
  template: "backbone/templates/map"
  itemView: Youngagrarians.Views.MapMarker
  map: null

  currentStep: 1
  previousStep: 0
  locationToAdd: null
  locationModel: null

  initialize: (options) ->
    @collection.on 'reset', (models) =>
      _.defer () =>
        @children.each ( child ) =>
          marker = child.createMarker()

  events:
    'click a#add-to-map' : 'addLocation'
    'click button.next'  : 'showNextStep'
    'click button.prev'  : 'showPrevStep'
    'click button#go-search' : 'doSearchProvince'
    'submit form#map-search-form' : 'doSearch'
    'click a#map-search-clear' : 'clearSearch'
    'click li.province' : 'changeProvince'

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

  showNextStep: (e) =>
    e.preventDefault()

    $("#step" + @currentStep).fadeOut()
    @previousStep = @currentStep
    @currentStep += 1
    @doStep()
    $("#step" + @currentStep).fadeIn()

  showPrevStep: (e) =>
    e.preventDefault()
    $("#step" + @currentStep).fadeOut()
    @previousStep = @currentStep
    @currentStep -= 1
    @doStep()
    $("#step" + @currentStep).fadeIn()

  doStep: () =>
    if @currentStep == 1
      @locationModel = new Youngagrarians.Models.Location

      $("input#location").val("")

      if !_.isNull @locationToAdd
        $.goMap.removeMarker @locationToAdd

    if @currentStep == 2
      _( $.goMap.getVisibleMarkers() ).each (id) ->
        $.goMap.showHideMarker id

      location = $("input#location").val()

      if !_.isEmpty location
        @locationToAdd = location
        $.goMap.setMap
          address: location
          zoom: 16

        $.goMap.createMarker
          address: location
          id: location

    if @currentStep == 3
      @locationModel.set 'address', @locationToAdd

    if @currentStep == 4
      $.goMap.setMap
        address: @locationToAdd

      @locationModel.set 'latitude', $.goMap.getMap().center.lat
      @locationModel.set 'longitude', $.goMap.getMap().center.lng

      category = window.Categories.get $("select#category").val()

      @locationModel.set 'category_id', $("select#category").val()
      @locationModel.set 'category', category
      @locationModel.set 'name', $("input#name").val()
      @locationModel.set 'description', $('textarea#description').val()
      @locationModel.set 'fb_url', $('input#facebok').val()
      @locationModel.set 'twitter_url', $('input#twitter').val()
      @locationModel.set 'url', $('input#url').val()
      @locationModel.set 'phone', $('input#phone').val()

      window.Locations.create @locationModel

      func = () ->
        $("#add-to-map").fadeIn()
        @currentStep = 1
        $("#add-to-map-form").slideUp()

      _.delay func, 10000


  addLocation: (e) =>
    e.preventDefault()
    $("#add-to-map").fadeOut()
    @currentStep = 1

    $("form#add-to-map-form ul.unstyled li").fadeOut()
    $("li#step" + @currentStep ).fadeIn()

    @doStep()

    $("#add-to-map-form").slideDown()

    select = $("select#category")
    window.Categories.each (model) =>
      opt = $("<option>")
        .attr( 'value', model.get('id'))
        .html model.get('name')
      select.append opt

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
