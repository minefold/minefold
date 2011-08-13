Mustache.templates = {}

Mustache.renderTemplate = (name, data) ->
  template = Mustache.templates[name]
  throw "Mustache template #{name} not found" unless template

  Mustache.to_html(template, data)

$('script[type="text/x-mustache"]').each ->
  name = $(@).data('name')
  # name = $(@).attr('id').replace('template-', '')
  Mustache.templates[name] = $(@).html()
