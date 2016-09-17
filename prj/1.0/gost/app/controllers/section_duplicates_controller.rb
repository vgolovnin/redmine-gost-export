class SectionDuplicatesController < GostPluginController

  def new
    @documents = @project.gost_documents
    @document = GostDocument.find(params[:gost_document_id])
    @duplicate = @document.nested_section(params[:section_id])
    render 'new', layout: false
  end

  def create
    @document = GostDocument.find(params[:gost_document_id])
    # fixme origin_document
    @section = @document.nested_section(params[:section_id])
    if params[:section_id] == params[:origin_id]
      flash[:error] = "Нельзя связать раздел сам с собой"
    else
      @origin = Section.find(params[:origin_id])
      @section.origin_id = @origin.id
      if @section.save
        flash[:notice] = "Разделы связаны"
      else
        flash[:error] = "Ошибка связывания"
      end
    end
    redirect_to edit_project_gost_document_section_path(@project, @document, @section)
  end

  def destroy

  end
end
