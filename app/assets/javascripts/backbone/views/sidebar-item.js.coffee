class Youngagrarians.Views.SidebarItem extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'category active'
  template: 'backbone/templates/sidebar-item'

  events:
    'click a.category-link' : 'filter'

  filter: (ev) =>
    ev.preventDefault()
    @$el.toggleClass 'active'
    @trigger 'filter', @$el

  onRender: =>
    @$el.data 'type', @model.get('type')
