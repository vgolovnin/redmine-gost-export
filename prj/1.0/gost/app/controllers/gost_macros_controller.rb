class GostMacrosController < GostPluginController
  menu_item :gost_documents
  def index
    @macros = @project.macros
  end

  def new
    @macro = @project.macros.build
  end

  def create
    @macro = @project.macros.create(params.require(:gost_macro).permit([:title, :text]))
    if @macro.errors.any?
      flash[:error] = "Ошибка при добавлении шаблона"
    else
      flash[:notice] = "Шаблон добавлен"
    end
    redirect_to action:'index'
  end

  def update
    @macro = @project.macros.find(params[:id])
    @macro.update(params.require(:gost_macro).permit([:title, :text]))
    render empty: true
  end

end