class Youngagrarians.Views.Sidebar extends Backbone.Marionette.View
  tagName: 'ul'
  className: 'nav nav-list'

  initialize: () ->
    @types = @options.locations.pluck 'type'
    @options.locations.on 'reset', @reset, @

  reset: (col,data) =>
    title = @make('li', {'class': 'nav-header'}, 'Categories')
    @$el.empty()
    @$el.append title
    @addAll()

  addAll: (col,data) =>
    @types = @options.locations.pluck 'type'
    _(@types).each @addOne

  addOne: (type) =>
    li =  @make 'li', {class: 'category'}, type
    @$el.append li

  make: (tagName, attributes, content) ->
    $el = Backbone.$ "<" + tagName + "/>"
    if attributes
      $el.attr attributes
    if content != null
      $el.html content
    $el[0]

  render: =>
    @reset()