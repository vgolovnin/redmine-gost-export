class GostController < ApplicationController

  #helper GostExportHelper
  # rescue_from GostExportExtension::ParseError, :with => :parse_error

  def index
    @project = Project.find(params[:id])
    @gost = Gost.new(@project)
  end

  def parse_error
    render plain: @page.title + " not in gost format"
  end

  def export
    @project = Project.find(params[:id])
    @gost =  Gost.new(@project)
    @gost.extract_definitions
    @document = @gost.page(params[:page_id]).to_gost

    @document.bibliography = @gost.bibliographies.each { |k, v|
      File.open(BUILD_DIR + "/#{k}.bib", "w") {|f| f.puts v}
    }.keys.join(',')

    File.open(BUILD_DIR + "/export.tex", "w") {|f| f.puts render_to_string template:  "gost/export.tex.erb", layout: false}
    File.open(GostExportExtension::LatexBuild.new.build, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => @document.title + ".pdf", :type => "application/pdf", :disposition => "attachment"
    end

  end

end