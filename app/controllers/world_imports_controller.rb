class WorldImportsController < ApplicationController
  def create
    Resque.enqueue(Job::ImportWorld, params[:world_import][:world_id], params[:world_import][:filename])
    render :nothing => true
  end
end