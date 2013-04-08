class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "result-item"
  template: "backbone/templates/result-item"

  initialize: (options) ->
    @model.on 'change', @changeShow, @

  changeShow: (model) =>
    if @model.get 'markerVisible'
      @$el.show()
    else
      @$el.hide()

    ###
    _(markers).each (latlng,i) =>
      id = ids[i]
      if id == @model.id
        console.log 'model visible: ', $.goMap.isVisible @model
        if $.goMap.isVisible @model
          @$el.show()
        else
          @$el.hide()

    _.delay () =>
      if @model.get 'markerVisible'
        @$el.show()
      else
        @$el.hide()
    ###