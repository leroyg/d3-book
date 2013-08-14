class ChaptersController < ApplicationController
  before_filter :prepend_view_paths

  def index
    if params[:id]
      @sections = Dir.glob(File.join("**", "chapter_#{params[:id]}", "*.html")).sort
    else
      @chapters = Dir.glob(File.join("**", "chapter_*"))
        .map {|p| /(\d+)$/.match(p)[0]}
        .sort
    end
  end

  def section
    render template: params[:section]
  end

  private
    def prepend_view_paths
      prepend_view_path "chapter_#{params[:id]}"
    end
end
