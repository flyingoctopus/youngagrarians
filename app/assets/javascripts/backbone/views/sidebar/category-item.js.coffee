#= require ./subcategory-item
class Youngagrarians.Views.CategoryItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/category-item"

  tagName: "option"

  itemView: Youngagrarians.Views.SubcategoryItem

  appendHtml: ( view, item, index ) =>
    console.log 'select subview: ', @$el[0].parentNode

    if index == 0
      optgroup = $("<optgroup>")
        .attr( 'label', @model.get("name") + " Sub-Categories" )

      $(view.el).after optgroup
      console.log 'optgroup!', optgroup[0]

    optgroup = @$el.next()
    console.log 'optgroup?', optgroup[0]

    console.log 'view: ', view, view.el
    console.log 'item: ',item
    console.log index
    console.log '-----------------------------'

  initialize: (options) =>
    @app = options.app
