module FacebookHelper

  def fb_head_prefix
    { 'og' => 'http://ogp.me/ns',
      'fb' => 'http://ogp.me/ns/fb',
      'minefold' => 'http://ogp.me/ns/fb/minefold'
    }.map {|t,url| "#{t}: #{url}#" }.join(' ')
  end

end
