class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "result-item"
  template: "backbone/templates/result-item"

  initialize: (options) ->
    @model.on 'change', @changeShow, @

  changeShow: (model) =>
    ###
    console.log 'name: ', @model.get 'name'
    console.log 'markerVisible:', @model.get 'markerVisible'
    console.log 'isVisible: ', $.goMap.isVisible(@model)
    ###
    if @model.get 'markerVisible'
      if $.goMap.isVisible @model
        @$el.show()
      else
        @$el.hide()
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