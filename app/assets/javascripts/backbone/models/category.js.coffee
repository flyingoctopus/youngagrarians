class Youngagrarians.Models.Category extends Backbone.RelationalModel
  paramRoot: 'category'

  defaults:
    name: null

  relations: [
    type: 'HasMany'
    key: 'subcategory'
    relatedModel: 'Youngagrarians.Models.Subcategory'
    includeInJSON: [Backbone.Model.prototype.idAttribute, 'name']
    collectionType: 'Youngagrarians.Collections.SubcategoryCollection'
    reverseRelation:
      key: 'location'
      includeInJSON: '_id'
  ]

  getIcon: =>
    return '/~youngagr/map/assets/map-icons/' + @get('name').toLowerCase().replace(' ', '-') + ".png"

Youngagrarians.Models.Category.setup()

class Youngagrarians.Collections.CategoriesCollection extends Backbone.Collection
  model: Youngagrarians.Models.Category
  url: '/~youngagr/map/categories'
