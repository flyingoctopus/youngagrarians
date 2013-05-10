class Youngagrarians.Views.Sidebar extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'nav nav-stacked nav-pills'
  id: 'sidebar'
  itemView: Youngagrarians.Views.SidebarItem

  initialize: () ->
    @on 'itemview:filter', @showHide

  onRender: =>
    @types = @collection.pluck 'name'
    $("#category-list").niceScroll
      cursorcolor: '#08c'
      autohidemode: false

  showHide: (ev) =>
    target = ev.el
    type = ev.model.get('name')

    if @types.indexOf(type) < 0
      @types.push type
    else
      @types = _(@types).without type

    @trigger 'filter', @types
