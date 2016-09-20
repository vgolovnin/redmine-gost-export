class SignersController < GostPluginController

  before_action ->{request.xhr?}

  def index
    @signers = @project.gost_info.signers
  end

  def update
    @signer = @project.gost_info.signers.find(params[:id])
    @signer.update(signer_params)
    render plain: 'ok'
  end

  def new
    @signer = @project.gost_info.signers.build
  end

  def create
    @signer = @project.gost_info.signers.create(signer_params)
    render js: 'hideModal();'
  end

  def destroy
    @signer = @project.gost_info.signers.find(params[:id])
    @signer.destroy
    render js: "$('#signer_#{params[:id]}').hide()"
  end

  private

  def signer_params
    params.require(:signer).permit([:name, :position, :role])
  end

end