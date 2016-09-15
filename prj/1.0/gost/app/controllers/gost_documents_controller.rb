class GostDocumentsController < GostPluginController

  def index
    @documents = @project.gost_documents
  end

  def new
    @templates = templates
    if params[:template].present?
      template_index = params[:template].to_i
      render_404 if template_index >= @templates.size || template_index < 0
      @document = @project.gost_documents.build.use_template(@templates[template_index])
      @document.save #fixme -> create
      redirect_to [@project, @document]
    else
      render 'templates'
    end
  end

  def create
    @document = @project.gost_documents.create(params.require(:gost_document).permit!) #fixme params
    redirect_to [@project, @document], action: :edit
  end

  def show
    @document = @project.gost_documents.find(params[:id]) || render_404
  end

  def destroy
    @document = @project.gost_documents.find(params[:id])
    @document.destroy
    redirect_to action: 'index'
  end

  def edit
    @document = @project.gost_documents.find(params[:id])
  end

  def update
    @document = @project.gost_documents.find(params[:id])
    @document.update(params.require(:gost_document).permit!)
    @document.save || flash[:error] = 'Not saved'
    redirect_to action: 'edit'
  end

  # def create_section
  #   @document = @project.gost_documents.find(params[:id])
  #   @document.sections.build
  # end

  def export
    @document = @project.gost_documents.find(params[:id])
    @info = @project.gost_info
    @bibs = GostBibliographicReference.get @project
    if @info.nil? #fixme || not @info.signers_set
      flash[:error] = "Set info first"
      redirect_to action: 'index'
    else
      tex = render_to_string 'export/document.tex.erb', layout: false
      send_file LatexBuild.new.build(tex), disposition: 'inline'
    end
  end

  private

  def templates
    YAML.load_file("#{Rails.root}/plugins/gost/config/data/documents_templates.yml")['templates']
  end
end
