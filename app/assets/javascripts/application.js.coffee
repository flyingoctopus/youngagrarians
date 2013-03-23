#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.gomap
#= require underscore
#= require backbone
#= require backbone.marionette
#= require backbone/youngagrarians
#= require bootstrap-setup

make = (tagName, attributes, content ) ->
  $el = Backbone.$ "<" + tagName + "/>"
  if attributes
    $el.attr attributes
  if content != null
    $el.html content
  $el[0]

Backbone.View.make = make
Backbone.Marionette.View.make = make

Backbone.Marionette.Renderer.render = (template, data) ->
  if !JST[template]
    throw "Template '" + template + "' not found!"
  JST[template](data)
