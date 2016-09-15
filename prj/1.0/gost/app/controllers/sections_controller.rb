class SectionsController < GostPluginController

  def edit
    @document = @project.gost_documents.find(params[:gost_document_id])
    #@section = @document.sections.find(params[:id])
    @section = Section.find_by_id(params[:id])
  end


  def update
    @document = @project.gost_documents.find(params[:gost_document_id])
    @section = @document.sections.find(params[:id])
    @section.update(params.require(:section).permit!)
    redirect_to action: 'edit'
  end
end