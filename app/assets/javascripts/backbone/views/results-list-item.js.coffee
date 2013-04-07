class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "result-item"
  template: "backbone/templates/result-item"

  initialize: ->
    @model.on 'change', @changeShow

  changeShow: (model) =>
    _.delay () =>
      console.log 'result item needs to be hidden?', @el, @model
      if @model.get 'markerVisible'
        @$el.show()
      else
        @$el.hide()
