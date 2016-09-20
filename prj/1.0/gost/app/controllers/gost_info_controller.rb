class GostInfoController < GostPluginController
  menu_item :gost_documents
  def edit
    @info = @project.gost_info
    if @info.nil?
      @info = GostInfo.new
      @info.project_id = @project.id
      @info.title = @project.name
      @info.save
    end
  end

  def update
    @info = @project.gost_info || GostInfo.new
    @info.update(params.require(:gost_info).permit!)
    @info.project_id = @project.id
    set_signers
    @info.save ? flash[:notice] = 'Saved' : flash[:error] = 'Not saved'
    redirect_to action: 'edit'
  end

  private

  def set_signers #fixme
    @info.signers.find(params[:agreed_id]).update(role: 1)
    @info.signers.find(params[:approved_id]).update(role: 2)
    @info.signers.find(params[:performer_id]).update(role: 3)
  end

end