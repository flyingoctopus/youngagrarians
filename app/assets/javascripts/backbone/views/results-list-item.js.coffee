class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "result-item"
  template: "backbone/templates/result-item"

  initialize: (options) ->
    @model.on 'change', @changeShow, @

  onShow: (options) =>
    @$el.find('a').attr 'href', @model.locUrl()

  changeShow: (model) =>
    if @model.get 'markerVisible'
      if $.goMap.isVisible @model
        @$el.show()
      else
        @$el.hide()
    else
      @$el.hide()
