class Youngagrarians.Views.Extras extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/extras"

  className: "extras"

  events:
    'click a#add-to-map': 'addLocation'
    'click a#show-about': 'showAbout'

  initialize: (options) =>
    @app = options.app

  addLocation: (e) =>
    e.preventDefault()
    console.log 'need to add location'
    newLocation = new Youngagrarians.Models.Location
    addLoc = new Youngagrarians.Views.AddLocation model: newLocation
    addLoc.render()

  showAbout: (e) =>
    e.preventDefault()
    about = new Youngagrarians.Views.About
    about.render()
