class GostBibliographyController < GostPluginController

  menu_item :gost_documents
  def index
    @bibs = GostBibliographicReference.get @project

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

    if params[:gost_bibliographic_reference][:bib_file].present?
      bibtext = params[:gost_bibliographic_reference][:bib_file].read
    else
      bibtext = params[:gost_bibliographic_reference][:text]
    end

      @bib = BibTeX.parse(bibtext)
      raise BibTeX::ParseError if @bib.errors? #FIXME check syntax

      @bib.each do |rbo|
       entry = @project.bibliographiс_references.build
       entry.rbo = rbo
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