class Youngagrarians.Views.Bioregions extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/bioregions"

  events:
    'change select#bioregions': 'changeBioregion'

  initialize: (options) =>
    @app = options.app

  changeBioregion: (e) =>
    e.preventDefault()
    console.log 'bioregion changed'