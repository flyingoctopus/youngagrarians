class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/result-item"
  tagName: "li"
  className: "result-item"

  serializeData: =>
    data = @model.toJSON()
    data.img = @model.get('category').getIcon()
    data.locUrl = @model.locUrl()
    data

  initialize: (options) ->
    @model.on 'change', @changeShow, @

  onShow: (options) =>
    @$el.hide()

  changeShow: (model) =>
    if @model.get 'markerVisible'
      if $.goMap.isVisible @model
        @$el.show()
      else
        @$el.hide()
    else
      @$el.hide()
