class SignersController < GostPluginController

  def new
    @signer = @project.gost_info.signers.build

    respond_to do |format|
      format.js
    end
  end

  def create
    @signer = @project.gost_info.signers.create(params.require(:signer).permit!)
    render js: 'hideModal(); location.reload(true);'
  end
end