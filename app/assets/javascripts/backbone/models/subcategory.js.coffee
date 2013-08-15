class Youngagrarians.Models.Subcategory extends Backbone.RelationalModel
  paramRoot: 'subcategories'

  defaults:
    name: null

  getIcon: =>
    return '~youngagr/map/assets/map-icons/' + @get('name').toLowerCase().replace(' ', '-') + ".png"

Youngagrarians.Models.Subcategory.setup()

class Youngagrarians.Collections.SubcategoryCollection extends Backbone.Collection
  model: Youngagrarians.Models.Subcategory
  url: '/~youngagr/map/subcategories'
