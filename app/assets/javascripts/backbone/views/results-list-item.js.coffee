class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "result-item"
  template: "backbone/templates/result-item"

  initialize: (options) ->
    @model.on 'change', @changeShow, @
    @ignore = ["Web","Web Resource", "Publication" ]

  onShow: (options) =>
    @$el.hide()
    if _(@ignore).indexOf( @model.get('category').get('name') ) >= 0
      @$el.find('a').attr('target','_blank').attr 'href', @model.get('url')
    else
      @$el.find('a').attr 'href', @model.locUrl()

  changeShow: (model) =>
    @$el.show()
    if _(@ignore).indexOf( @model.get('category').get('name') ) == -1
      if @model.get 'markerVisible'
        if $.goMap.isVisible @model
          @$el.show()
        else
          @$el.hide()
      else
        @$el.hide()
