window.delay = (ms, fn) ->
  setTimeout(fn, ms)

window.every = (ms, fn) ->
  setInterval(fn, ms)

window.pluralize = (num, singular, plural) ->
  "#{num} " + if num is 1 then singular else plural
