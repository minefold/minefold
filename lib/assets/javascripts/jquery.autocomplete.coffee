template = _.template """
  <a id="<%= id %>">
    <img src="https://secure.gravatar.com/avatar/<%= gravatar_id %>.png?format=png&amp;height=18&amp;r=PG&amp;width=18" width="18" height="18" />
    <%= username %>
  </a>
"""

jQuery.fn.autocomplete = ->
  self = @
  results = $('.autocomplete-results')
  players = $('.whitelisted-players')

  results.find('a').live 'click', ->
    a = $(@)
    li = $('<li></li>').attr(id: a.attr('id')).html(a.html())
    li.append $('<a class="remove">Remove</a>')
    li.append $('<input type="hidden" name="world[fucking_whitelist_ids][]" />').val(a.attr('id'))
    players.append li
    self.val('')
    results.empty()

  @keyup (e) ->
    if self.val().length < 2
      results.empty()
    else
      $.ajax
        url: self.data('source')
        dataType: 'json'
        data: {q: self.val()}
        success: (data) ->
          results.empty()
          for player in data
            results.append $(template(player))
