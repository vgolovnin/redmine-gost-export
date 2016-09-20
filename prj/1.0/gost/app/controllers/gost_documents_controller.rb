class GostDocumentsController < GostPluginController
  menu_item :gost_documents

  helper :attachments
  def index
    @documents = @project.gost_documents
  end

  def new
    @templates = templates
    respond_to do |format|
      format.js
    end
  end

  def create
    @templates = templates
    if params[:template].present?
      template_index = params[:template].to_i
      render_404 if template_index >= @templates.size || template_index < 0
      @document = @project.gost_documents.build.use_template(@templates[template_index])
      @document.save
      redirect_to [@project, @document]
    end
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
    if @info.nil? or not Signer.all_set_for_project(@project)
      flash[:error] = "Необходимо задать информацию о проекте и подписывающие лица"
      redirect_to action: 'index'
    else

      builder = LatexBuild.new(@project, @bibs)
      pdf = builder.build(@document)
      errors = builder.errors(@document.title)
      if errors.any?
        render plain: "Ошибки при сборке:\n" + errors.join("\n")
      else
        send_file pdf, disposition: 'inline'
      end

    end
  end

  private

  def templates
    YAML.load_file("#{Rails.root}/plugins/gost/config/data/documents_templates.yml")['templates']
  end
end
