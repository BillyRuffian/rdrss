class SourcesController < ApplicationController
  def create
    source = Source.new(params[:url])
    
  end

  def show
  end

  def new
  end
end
