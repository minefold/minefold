$ = jQuery

$.fn.extend
    embedify: ->
      replaceURLWithHTMLLinks = (text) ->
        exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
        text.replace exp, "<a href='$1'>$1</a>"
      
      @each ->
        $body = $(this)
        plainText = $(this).text()
                
        $(this).html replaceURLWithHTMLLinks(plainText)
        
        urls = []
        $('a', this).each -> urls.push $(this).attr('href')
        
        if urls.length > 0
          $.ajax
            url: 'http://api.embed.ly/1/oembed'
            dataType: 'jsonp'
            data:
              key: '739f2006c30d11e089e14040d3dc5c07'
              url: urls[0]
            success: (oembed) ->
              console.log oembed
              # // height: 752
              # // provider_name: "Imgur"
              # // provider_url: "http://imgur.com"
              # // thumbnail_height: 90
              # // thumbnail_url: "http://imgur.com/I2juOs.png"
              # // thumbnail_width: 90
              # // type: "photo"
              # // url: "http://imgur.com/I2juO.png"
              # // version: "1.0"
              # // width: 1280

              if oembed.thumbnail_url
                $body.after "<div class=\"media\"><a href=\"#{oembed.url}\"><img class=\"thumbnail\" src=\"#{oembed.thumbnail_url}\" /></a></div>"
              
  

