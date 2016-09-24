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
    @info.save ? flash[:notice] = 'Информация о проекте сохранена' : flash[:error] = 'Not saved'
    redirect_to action: 'edit'
  end
end