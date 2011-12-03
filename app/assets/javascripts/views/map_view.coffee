class window.MapView extends Backbone.View
  id: 'map'

  options:
    zoom: 0
    center: new google.maps.LatLng(0.5, 0.5)
    navigationControl: false
    scaleControl: false
    mapTypeControl: false
    streetViewControl: false
    mapTypeId: 'map'

  constructor: ->

  render: ->
    console.log @options
    new google.maps.Map(@el, @options);



# //       var mapOptions = {
# //         zoom: config.defaultZoom,
# //         center: new google.maps.LatLng(0.5, 0.5),
# //         navigationControl: true,
# //         scaleControl: false,
# //         mapTypeControl: false,
# //         streetViewControl: false,
# //         mapTypeId: 'map'
# //       };
# //       map = new google.maps.Map(document.getElementById('map'), mapOptions);
# //
# //
# //       // Now attach the coordinate map type to the map's registry
# //       map.mapTypes.set('map', MCMapType);
# //
# //       // We can now set the map to use the 'coordinate' map type
# //       map.setMapTypeId('map');
# //
# //       initMarkers();


# (function($){
#
#   $.world_map = function(options) {
#     var config = $.extend({
#       path:        '.',
#       fileExt:     'png',
#       tileSize:     2048,
#       defaultZoom:  0,
#       B:            2,
#       T:            16,
#       maxZoom:      4
#     }, options);
#
#     var markerData = [
#       {"msg": "center of chunk (0,0) at sea level", "y": 64, "x": 8, "z": 8}
#     ]
#
#     // our custom projection maps Latitude to Y, and Longitude to X as normal,
#     // but it maps the range [0.0, 1.0] to [0, tileSize] in both directions
#     // so it is easier to position markers, etc. based on their position
#     // (find their position in the lowest-zoom image, and divide by tileSize)
#     function MCMapProjection() {
#       this.inverseTileSize = 1.0 / config.tileSize;
#     }
#
#     MCMapProjection.prototype.fromLatLngToPoint = function(latLng) {
#       var x = latLng.lng() * config.tileSize;
#       var y = latLng.lat() * config.tileSize;
#       return new google.maps.Point(x, y);
#     };
#
#     MCMapProjection.prototype.fromPointToLatLng = function(point) {
#       var lng = point.x * this.inverseTileSize;
#       var lat = point.y * this.inverseTileSize;
#       return new google.maps.LatLng(lat, lng);
#     };
#
#     // pigmap lat/long converter
#     // this function takes its arguments in the *same order* as the previous
#     //  Overviewer version--minecraft X, minecraft Y, minecraft Z--so callers
#     //  do not need to be changed
#     // ...however, this one does not rename the variables, so what we call "y"
#     //  here is also called "y" in both minecraft and pigmap
#     // (the pigmap docs write coords in X,Z,Y order, so unfortunately
#     //  confusion is still possible, but at least the *names* are the same)
#     function fromWorldToLatLng(x, y, z) {
#       // the width and height of all the highest-zoom tiles combined, inverted
#       var perPixel = 1.0 / (config.tileSize * Math.pow(2, config.maxZoom));
#
#       var B = config.B;
#       var T = config.T;
#
#       // fail in a conspicuous way if tileSize doesn't match B and T
#       if (config.tileSize != 64*B*T) {
#           // console.log("Tile size does not match 64*B*T");
#           return new google.maps.LatLng(0.5, 0.5);
#       }
#       // the center of block [0,0,0] is at [2B, 64BT-17B] in the tile [tiles/2, tiles/2]
#       var lng = 0.5 + 2*B * perPixel;
#       var lat = 0.5 + (config.tileSize - 17*B) * perPixel;
#
#       // each block on X adds [2B,-B]
#       lng += 2*B * x * perPixel;
#       lat += -B * x * perPixel;
#
#       // each block on Y adds [0,-2B]
#       lat += -2*B * y * perPixel;
#
#       // each block on Z adds [2B,B]
#       lng += 2*B * z * perPixel;
#       lat += B * z * perPixel;
#
#       return new google.maps.LatLng(lat, lng);
#      }
#
#     var MCMapOptions = {
#       getTileUrl: function(tile, zoom) {
#         var url = config.path;
#         if(tile.x < 0 || tile.x >= Math.pow(2, zoom) || tile.y < 0 || tile.y >= Math.pow(2, zoom)) {
#           url += '/blank';
#         } else if(zoom == 0) {
#           url += '/base';
#         } else {
#           for(var z = zoom - 1; z >= 0; --z) {
#             var x = Math.floor(tile.x / Math.pow(2, z)) % 2;
#             var y = Math.floor(tile.y / Math.pow(2, z)) % 2;
#             url += '/' + (x + 2 * y);
#           }
#         }
#         url = url + '.' + config.fileExt;
#         return(url);
#       },
#       tileSize: new google.maps.Size(config.tileSize, config.tileSize),
#       maxZoom:  config.maxZoom,
#       minZoom:  0,
#       isPng:    !(config.fileExt.match(/^png$/i) == null)
#     };
#
#     var MCMapType = new google.maps.ImageMapType(MCMapOptions);
#     MCMapType.name = "MC Map";
#     MCMapType.alt = "Minecraft Map";
#     MCMapType.projection = new MCMapProjection();
#
#     function CoordMapType() {
#     }
#
#     function CoordMapType(tileSize) {
#       this.tileSize = tileSize;
#     }
#
#     CoordMapType.prototype.getTile = function(coord, zoom, ownerDocument) {
#       var div = ownerDocument.createElement('DIV');
#       div.innerHTML = "(" + coord.x + ", " + coord.y + ", " + zoom + ")";
#       div.innerHTML += "<br />";
#       div.innerHTML += MCMapOptions.getTileUrl(coord, zoom);
#       div.style.width = this.tileSize.width + 'px';
#       div.style.height = this.tileSize.height + 'px';
#       div.style.fontSize = '10';
#       div.style.borderStyle = 'solid';
#       div.style.borderWidth = '1px';
#       div.style.borderColor = '#AAAAAA';
#       return div;
#     };
#
#     var map;
#
#     var markersInit = false;
#
#     function initMarkers() {
#       if (markersInit) { return; }
#
#       markersInit = true;
#
#       for (i in markerData) {
#         var item = markerData[i];
#
#         var converted = fromWorldToLatLng(item.x, item.y, item.z);
#          var marker = new google.maps.Marker({
#           position: converted,
#           map: map,
#           title: item.msg,
#
#           });
#
#      }
#     }
#
#     function initialize() {
#       var mapOptions = {
#         zoom: config.defaultZoom,
#         center: new google.maps.LatLng(0.5, 0.5),
#         navigationControl: true,
#         scaleControl: false,
#         mapTypeControl: false,
#         streetViewControl: false,
#         mapTypeId: 'map'
#       };
#       map = new google.maps.Map(document.getElementById('map'), mapOptions);
#
#
#       // Now attach the coordinate map type to the map's registry
#       map.mapTypes.set('map', MCMapType);
#
#       // We can now set the map to use the 'coordinate' map type
#       map.setMapTypeId('map');
#
#       initMarkers();
#     }
#
#     initialize();
#   }
#
# })(jQuery);

