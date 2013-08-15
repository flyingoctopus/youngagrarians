class Youngagrarians.Views.Provinces extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/provinces"

  events:
    'change select#provinces': 'changeProvince'

  initialize: (options) =>
    @app = options.app

  changeProvince: (e) =>
    e.preventDefault()
    selected = $(e.target).find(":selected")
    @app.vent.trigger 'province:change', { country: selected.data('country'), province: selected.data('province') }