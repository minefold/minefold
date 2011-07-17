//= require jquery
//= require jquery_ujs
//= require_tree .

var products = $('#products li');
products.click(function(e) {
  var self = $(e.currentTarget);
  products.removeClass('active');
  self.addClass('active').find('input:radio').click();
  e.preventDefault();
});
