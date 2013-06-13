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

  changeCategory: (e) =>
    e.preventDefault()
    console.log 'category changed'