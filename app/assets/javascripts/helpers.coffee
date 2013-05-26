window.delay = (ms, fn) ->
  setTimeout(fn, ms)

window.every = (ms, fn) ->
  setInterval(fn, ms)

window.pluralize = (num, singular, plural) ->
  "#{num} " + if num is 1 then singular else plural

window.rand = (n) ->
  Math.floor(Math.random() * n)

window.centsToCurrency = (n) ->
  "$#{n / 100}.00"

window.formatNumber = (n) ->
  n += ''
  x = n.split('.')
  x1 = x[0]
  x2 = if x.length > 1 then '.' + x[1] else ''

  rgx = /(\d+)(\d{3})/
  while rgx.test(x1)
    x1 = x1.replace(rgx, '$1' + ',' + '$2')

  return x1 + x2
