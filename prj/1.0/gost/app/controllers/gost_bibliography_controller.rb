class GostBibliographyController < GostPluginController

  def index
    @bibs = GostBibliographicReference.get @project

    if @bibs.errors?
      flash[:error] = "BIB error"
    end

    respond_to do |format|
      format.html
      format.json {render json: @bibs.map{|bib| {
          id: bib.id,
          title: bib.title
      }}}
    end
  end

  def new
    @bib = @project.bibliographiс_references.build
  end

  def create
      @bib = BibTeX.parse(params[:gost_bibliographic_reference][:text])
      raise BibTeX::ParseError if @bib.errors? #FIXME check syntax

      @bib.each do |rbo|
       entry = @project.bibliographiс_references.build
       entry.rbo = rbo
       #entry.project_id = @project.id
       entry.save
      end

      redirect_to action: 'index'
    rescue BibTeX::ParseError => e
      flash[:error] = e.message
      redirect_to action: 'new'
  end

  def destroy
    @document = @project.bibliographiс_references.find(params[:id])
    @document.destroy
    redirect_to action: 'index'
  end
end