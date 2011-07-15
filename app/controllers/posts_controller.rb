class PostsController < ApplicationController

  def create
    @world = Word.first slug: params[:slug]
  end

end
