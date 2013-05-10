module AbbaHelper

  # this is very simple, one control, one variant, one per page
  # you need to have .ab-control and .ab-variant
  def ab_test(name, variant)
    js = <<-EOF
      Abba('#{name}')
        .control('Control', {}, function(){
          $('.ab-control').show();
        }).variant('#{variant}', {}, function(){
          $('.ab-variant').show();
        }).start();
    EOF

    content_for :tail do
      content_tag :script, js.html_safe
    end
  end
end
