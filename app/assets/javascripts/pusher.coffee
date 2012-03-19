pusher_key = $('meta[name="pusher:key"]').attr('content')
mf.pusher = new Pusher(pusher_key, encrypted: true)
