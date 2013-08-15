class ChaptersController < ApplicationController
  before_filter :prepend_view_paths
  before_filter :find_sections, only: [:index, :show]

  # "overloaded" index action that shows the list of chapters,
  # and the list of sections if chapter id is known
  def index
    unless params[:id]
      @chapters = Dir.glob(File.join("**", "chapter_*"))
        .map {|p| /(\d+)$/.match(p)[0]}
        .sort
    end
  end

  # "overloaded" show action that renders the show view for html requests,
  # and raw data for all other request types
  def show
    @short_link = true

    respond_to do |format|
      format.html { render :show }
      format.any { render template: params[:section] }
    end
  end

  def d3
    # comment the following line to use static library instead
    # return render js: Rails.application.assets.find_asset('d3.v3.js')

    prepend_view_path "d3"
    render file: 'd3.v3.js', content_type: Mime::JS.to_s
  end

  private
    def prepend_view_paths
      prepend_view_path "chapter_#{params[:id]}"
    end

    def find_sections
      if params[:id]
        @sections = Dir.glob(File.join("**", "chapter_#{params[:id]}", "*.html")).sort
      end
    end
end
