class Youngagrarians.Models.Location extends Backbone.RelationalModel
  paramRoot: 'location'
  url: '/~youngagr/locations'

  relations: [
    type: 'HasOne'
    key: 'category'
    relatedModel: 'Youngagrarians.Models.Category'
    includeInJSON: Backbone.Model.prototype.idAttribute,
    collectionType: 'Youngagrarians.Collections.CategoriesCollection'
    reverseRelation:
      key: 'location'
      includeInJSON: '_id'
  ]

  defaults:
    latitude: null
    longitude: null
    gmaps: null
    address: null
    name: null
    content: null
    markerVisible: true

  lat: =>
    return @get 'latitude'

  lng: =>
    return @get 'longitude'

  locUrl: =>
    base = $("#root_url").data('url') + "#" + '/locations/' + @id

Youngagrarians.Models.Location.setup()

class Youngagrarians.Collections.LocationsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  url: '/~youngagr/locations'
  show: []

  initialize: (options) ->
    @direct = false
    @on 'map:update', @mapUpdate, @

  setShow: (ids) =>
    @show = ids
    categories = []
    $("li.category.active").each (i,el) ->
      categories.push $(el).data 'type'
    @mapUpdate
      type: 'filter'
      data: categories

  clearShow: () =>
    @show = []
    categories = []
    $("li.category.active").each (i,el) ->
      categories.push $(el).data 'type'

    @mapUpdate
      type:
        'filter'
      data:
        categories

  mapUpdate: (data) =>
    ids = $.goMap.markers
    markers = $.goMap.getMarkers()

    if data.type == "filter"
      data = data.data
      _(markers).each (latlng,i) =>
        id = ids[i].replace("location-","")
        m = @get id
        if !_.isUndefined(m) and !_.isNull(m)
          catGood = _(data).indexOf( m.get('category').get('name') ) >= 0
          showGood = if @show.length > 0 then _(@show).indexOf(m.id) >= 0 else true

          if catGood and showGood
            $.goMap.showHideMarker 'location-'+m.id, true
            m.marker.setVisible true
          else
            $.goMap.showHideMarker 'location-'+m.id, false
            m.marker.setVisible false

          m.set 'markerVisible', m.marker.visible

    else if data.type == "show"
      $.goMap.setMap
        latitude: data.data.lat()
        longitude: data.data.lng()
        zoom: 10

      @direct = true

      _(markers).each (latlng, i) =>
        id = parseInt ids[i].replace("location-","")
        if id != data.data.get("id")
          $.goMap.showHideMarker ids[i], false
        else
          $.goMap.showHideMarker ids[i], true
        loc = @get(id)
        loc.set 'markerVisible', loc.marker.visible
    else
      if @direct
        @direct = false
        _(markers).each (latlng, i) =>
          $.goMap.showHideMarker ids[i], true
          loc = @get ids[i]

      categories = []
      $("li.category.active").each (i,el) ->
        categories.push $(el).data 'type'

      _(markers).each (latlng, i) =>
        id = parseInt ids[i].replace("location-","")
        location = @get id
        if !_.isUndefined(location) and !_.isNull(location)
          catGood = _(categories).indexOf( location.get('category').get('name') ) >= 0
          showGood = if @show.length > 0 then _(@show).indexOf(location.id) >= 0 else true
          markerVisible = location.get 'markerVisible'
          goMapVis = $.goMap.isVisible location

          if !location.get('markerVisible') and $.goMap.isVisible(location)
            if catGood and showGood
              $.goMap.showHideMarker ids[i], true

          else if location.get('markerVisible') and !$.goMap.isVisible(location)
            $.goMap.showHideMarker ids[i], false

        location.set "markerVisible", location.marker.visible

    true
