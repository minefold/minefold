class WorldImportsController < ApplicationController
  def create
    world_id = params[:world_import][:world_id]
    filename = "#{world_id}-#{params[:world_import][:filename]}"
    Resque.enqueue(Job::ImportWorld, world_id, s3_sanitize(filename))
    render :nothing => true
  end
  
  protected
  
  def s3_sanitize filename
    filename.gsub /[ !'"]/, '_'
  end
end