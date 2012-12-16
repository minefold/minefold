# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://minefold.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
  add '/xmas'

  PagesController.action_methods.reject{ |r| r=~/callback/ }.each do |route|
    add "/#{route}"
  end

  Server.find_each do |server|
    add server_path(server), lastmod: server.updated_at
    add map_server_path(server), lastmod: server.world.updated_at
  end
end
