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


do ->
  lastTime = 0
  vendors = ['ms', 'moz', 'webkit', 'o']
  for vendor in vendors when !window.requestAnimationFrame
    window.requestAnimationFrame = window[vendor + 'RequestAnimationFrame']
    window.cancelAnimationFrame  = window[vendor + 'CancelRequestAnimationFrame']

  if !window.requestAnimationFrame
    window.requestAnimationFrame = (cb, el) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = delay(timeToCall, -> cb(currTime + timeToCall))

      lastTime = currTime + timeToCall
      id

  if !window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout(id)
