#= require jquery.s3upload

newWorldForm = $('form#new_world')

newWorldForm.find('.data li').click ->
  self = $(@)

  # Menu
  self.siblings().removeClass('active')
  self.addClass('active')

  # Sections
  newWorldForm.find('.data section:visible').hide()
  newWorldForm.find(".data section").each ->
    section = $(@)
    if _.intersection(self.attr('class').split(' '), section.attr('class').split(' ')).length > 0
      section.show()


