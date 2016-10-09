class SectionsController < GostPluginController
  menu_item :gost_documents

  helper :gost_documents
  helper :attachments

  def new
    @document = @project.gost_documents.find(params[:gost_document_id])

    if params[:parent_id].present?
      @parent = @document.nested_section(params[:parent_id])
    else
      @parent = @document
    end
    index = @parent.sections.any? ? @parent.sections.map{|s| s.index}.max + 1 : 0
    @section = @parent.sections.build(index: index)
  end

  def create
    @document = @project.gost_documents.find(params[:gost_document_id])
    if params[:section][:parent_id].present?
      @parent = @document.nested_section(params[:section][:parent_id])
    else
      @parent = @document
    end
    @section = @parent.sections.create(params.require(:section).permit([:index, :title, :is_appendix]))
    if @section.errors.any?
      flash[:error] = @section.errors
    end
    render js: 'location.reload();'
  end

  def edit
    @document = @project.gost_documents.find(params[:gost_document_id])
    @section = @document.nested_section(params[:id])
  end

  def update
    @document = @project.gost_documents.find(params[:gost_document_id])
    @section = @document.nested_section(params[:id])

    @section.update(params.require(:section).permit!)

    Attachment.attach_files(@section, params[:attachments])
    redirect_to action: 'edit'
  end

  def destroy
    @document = @project.gost_documents.find_by_id(params[:gost_document_id])
    @section = @document.nested_section(params[:id])
    @parent = @section.parent
    @section.destroy

    if @parent.class == GostDocument
      redirect_to [@project, @document]
    else
      redirect_to edit_project_gost_document_section_path(@project, @document, @parent)
    end

  end
end