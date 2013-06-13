class Youngagrarians.Views.Provinces extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/provinces"

  events:
    'change select#provinces': 'changeProvince'

  initialize: (options) =>
    @app = options.app

  changeProvince: (e) =>
    e.preventDefault()
    console.log 'province changed'