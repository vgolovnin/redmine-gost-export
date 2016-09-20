class SectionsController < GostPluginController
  menu_item :gost_documents

  helper :attachments


  def edit
    @document = @project.gost_documents.find(params[:gost_document_id])
    @section = @document.nested_section(params[:id])
  end

  def update
    @document = @project.gost_documents.find(params[:gost_document_id])
    @section = @document.nested_section(params[:id])

    if @section.helper.nil?
      @section.update(params.require(:section).permit!)
      Attachment.attach_files(@section, params[:attachments])

    else
      @section.helper.update(settings: helper_settings_list(@section.helper.name))
    end

    redirect_to action: 'edit'
  end


  private

  def helper_settings_list(name)
    case name
      when 'functional_requirments'
        {issue_category_ids: params[:issue_category_ids]}
    end
  end
end