# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

loadLinkedIn = ->
  delete IN
  $.getScript("//platform.linkedin.com/in.js")
  lang: 'en_US'
 
$(document).ready(loadLinkedIn)
$(document).on('page:load', loadLinkedIn)