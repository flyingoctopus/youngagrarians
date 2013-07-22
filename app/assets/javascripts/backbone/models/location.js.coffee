class Youngagrarians.Models.Location extends Backbone.RelationalModel
  paramRoot: 'location'
  url: '/~youngagr/map/locations'

  relations: [
    {
      type: 'HasOne'
      key: 'category'
      relatedModel: 'Youngagrarians.Models.Category'
      includeInJSON: Backbone.Model.prototype.idAttribute,
      collectionType: 'Youngagrarians.Collections.CategoriesCollection'
      reverseRelation:
        key: 'location'
        includeInJSON: '_id'
    }
  ]

  defaults:
    latitude: null
    longitude: null
    gmaps: null
    address: null
    name: null
    content: null
    markerVisible: false

  lat: =>
    return @get 'latitude'

  lng: =>
    return @get 'longitude'

  locUrl: =>
    base = $("#root_url").data('url') + "#" + '/locations/' + @id

Youngagrarians.Models.Location.setup()

class Youngagrarians.Collections.LocationsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  url: '/~youngagr/map/locations'
  show: []

  country: null
  province: null
  bioregion: null
  category: null
  subcategory: null

  provinceShorthand:
    "Canada":
      "BC": "British Columbia"
      "AB": "Alberta"
      "SK": "Saskatchewan"
      "MB": "Manitoba"
      "ON": "Ontario"
      "QC": "Quebec"
      "NB": "New Brunswick"
      "NS": "Nova Scotia"
      "PEI": "Prince Edward Island"
      "NV": "Nunavut"
      "NT": "Northwest Territories"
      "YK": "Yukon"
      "NF": "Newfoundland"
    "USA":
      "OR": "Oregon"

  countryAlts:
    "Canada" : []
    "USA" : ["United States","US"]

  initialize: (options) ->
    @direct = false
    @on 'map:update', @mapUpdate, @

  setShow: (ids) =>
    @show = ids
    @mapUpdate
      type: 'update'

  clearShow: () =>
    @show = []
    @mapUpdate
      type: 'update'

  isEmpty: (val) =>
    return _.isUndefined(val) || _.isNull(val)

  mapUpdate: (data) =>
    ids = $.goMap.markers
    markers = $.goMap.getMarkers()

    if !_.isUndefined(data.data) and !_.isNull(data.data)
      @country = data.data.country
      @bioregion = data.data.bioregion
      @category = data.data.category
      @subcategory = data.data.subcategory
      @province = data.data.province

    if data.type == 'update'
      _(markers).each (latlng,i) =>
        id = ids[i].replace "location-", ""
        m = @get id
        if !_.isUndefined(m) and !_.isNull(m)
          goodToShow = true
          if !_.isNull @category
            locationCategory = m.get('category').id
            goodToShow = goodToShow && ( locationCategory == @category )

          if !_.isNull @subcategory
            locationSubcategories = m.get('subcategory').pluck('id')
            goodToShow = goodToShow && ( _(locationSubcategories).indexOf( @subcategory ) >= 0 )

          locationAddress = m.get("address")
          if !_.isNull(@province) and !_.isUndefined(@province)
            shortMatch = locationAddress.match @province
            fullMatch =  locationAddress.match @provinceShorthand[ @country ][ @province ]
            goodToShow = goodToShow && ( !_.isNull( shortMatch ) or !_.isNull(fullMatch) )
          else
            if !_.isNull( @country )
              countryMatch = !_.isNull locationAddress.match @country
              altMatch = false
              _( @countryAlts[ @country ] ).each (country ) =>
                if !_.isNull( locationAddress.match country )
                  altMatch = true

              goodToShow = goodToShow && ( countryMatch || altMatch )

          if !_.isNull @bioregion
            parts = @bioregion.split '-'

            testBio = m.get('bioregion')
            anyMatch = false
            anyMatch = anyMatch || !_.isNull( testBio.match( part ) ) for part in parts

            goodToShow = goodToShow && anyMatch

          if @show.length > 0
            goodToShow = goodToShow && ( _(@show).indexOf(m.id) >= 0 )

          if @isEmpty( @category )
            #and @isEmpty( @country ) and @isEmpty( @province ) and @isEmpty( @bioregion ) and @show.length == 0
            goodToShow = false

          m.marker.setVisible goodToShow
          m.set markerVisible: goodToShow

    if data.type == 'zoom' or data.type == 'dragend'
      _(markers).each (latlng, i) =>
        id = parseInt ids[i].replace("location-","")
        location = @get id
        if !_.isUndefined(location) and !_.isNull(location)
          isVisible = location.get 'markerVisible'
          location.set 'markerVisible', ( isVisible && $.goMap.isVisible(location) )

    if data.type == 'filter'
      console.log 'filtering?'

    if data.type == 'show'
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


    true
