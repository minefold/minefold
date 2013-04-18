module FunpacksHelper

  def funpack_image_path(funpack)
    "funpacks/#{funpack.slug}.png"
  end

  def funpack_public_template(funpack)
    File.join('funpacks', 'public', funpack.slug.gsub('-', '_'))
  end

end
