#= require ./category-item
class Youngagrarians.Views.Categories extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/categories"

  serializeData: =>
    data =
      items: @collection.toJSON()
    data

  events:
    'change select#category': 'changeCategory'

  initialize: (options) =>
    @app = options.app
    @collection.on 'reset', @render
    @app.vent.on 'legend:clicked', @legendClicked

  legendClicked: (e) =>
    @$el.find("select#category").val e
    @app.vent.trigger 'category:change', e

  changeCategory: (e) =>
    e.preventDefault()
    selected = $(e.target).find(':selected')
    categoryId = selected.data('cat')

    console.log 'category changed'

    if _.isUndefined categoryId
      subcategoryId = selected.data('subcat')
      categoryId = selected.parent().data 'cat'
      @app.vent.trigger 'subcategory:change', { cat: categoryId, subcat: subcategoryId }
    else
      @app.vent.trigger 'category:change', categoryId
