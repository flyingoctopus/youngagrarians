class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/result-item"
  tagName: "li"
  className: "result-item"

  category: null
  subcategory: null
  bioregion: null

  serializeData: =>
    data = @model.toJSON()
    data.img = @model.get('category').getIcon()
    data.locUrl = @model.locUrl()
    data

  initialize: (options) ->
    @app = options.app
    #@app.vent.on 'category:change', @categoryChanged
    #@app.vent.on 'subcategory:change', @subcategoryChanged
    #@app.vent.on 'bioregion:change', @bioregionChanged
    @model.on 'change', @changeShow, @

  onShow: (options) =>
    @$el.hide()

  categoryChanged: (cat) =>
    @category = cat
    if @model.get('category').get('id') == cat
      @$el.show()
    else
      @$el.hide()

  subcategoryChanged: (data) =>
    @category = data.cat
    @subcategory = data.subcat

    modelSubcategories = _(@model.get('subcategory')).pluck('id')

    if @model.get('category').get('id') == @category and _(modelSubcategories).indexOf(@subcategory) >= 0
      @$el.show()
    else
      @$el.hide()

  bioregionChanged: (data) =>
    bio = @model.get("bioregion")
    match = data.match bio

    if bio.length > 0 and !_.isNull(match)
      @$el.show()
    else
      @$el.hide()

  changeShow: (model) =>
    console.log 'marker visible: ', @model.get 'markerVisible'
    if @model.get 'markerVisible'
      if $.goMap.isVisible @model
        @$el.show()
      else
        @$el.hide()
    else
      @$el.hide()
