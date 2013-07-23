class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/result-item"
  tagName: "li"
  className: "result-item"

  category: null
  subcategory: null

  serializeData: =>
    data = @model.toJSON()
    data.img = @model.get('category').getIcon()
    data.locUrl = @model.locUrl()
    data

  initialize: (options) ->
    @app = options.app
    @app.vent.on 'category:change', @categoryChanged
    @app.vent.on 'subcategory:change', @subcategoryChanged

    #@model.on 'change', @changeShow, @

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

    console.log @category, @model.get('category').get('id')
    console.log @subcategory, modelSubcategories
    console.log @model.get('category').get('id') == @category, _(modelSubcategories).indexOf(@subcategory) >= 0
    console.log '------------------------'

    if @model.get('category').get('id') == @category and _(modelSubcategories).indexOf(@subcategory) >= 0
      @$el.show()
    else
      @$el.hide()

  changeShow: (model) =>
    if @model.get 'markerVisible'
      if $.goMap.isVisible @model
        @$el.show()
      else
        @$el.hide()
    else
      @$el.hide()
