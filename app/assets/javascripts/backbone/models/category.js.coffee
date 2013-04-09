class Youngagrarians.Models.Category extends Backbone.RelationalModel
  paramRoot: 'category'

  defaults:
    name: null

Youngagrarians.Models.Category.setup()

class Youngagrarians.Collections.CategoriesCollection extends Backbone.Collection
  model: Youngagrarians.Models.Category
  url: '/categories'
