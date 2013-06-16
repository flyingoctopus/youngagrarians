#= require ./subcategory-item
class Youngagrarians.Views.CategoryItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/category-item"

  tagName: "option"

  itemView: Youngagrarians.Views.SubcategoryItem

  appendHtml: ( view, item, index ) =>
    if index == 0
      optgroup = $("<optgroup>")
      #.attr( 'label', @model.get("name") + " Sub-Categories" )
      $(view.el).after optgroup

    optgroup = @$el.next()

  initialize: (options) =>
    @app = options.app
