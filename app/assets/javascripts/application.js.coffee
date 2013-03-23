#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery.gomap
#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require backbone.marionette
#= require backbone/youngagrarians
#= require_tree .


Backbone.View.make = (tagName, attributes, content ) ->
  $el = Backbone.$ "<" + tagName + "/>"
  if attributes
    $el.attr attributes
  if content != null
    $el.html content
  $el[0]

Backbone.Marionette.View.make = Backbone.View.make

Backbone.Marionette.Renderer.render = (template, data) ->
  if !JST[template]
    throw "Template '" + template + "' not found!"
  JST[template](data)
