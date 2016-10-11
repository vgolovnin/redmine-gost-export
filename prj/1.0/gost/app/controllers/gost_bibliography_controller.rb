class GostBibliographyController < GostPluginController

  menu_item :gost_documents
  def index
    @bibs = GostBibliographicReference.get @project

     render json: @bibs.map{|bib| {
          id:  bib.rbo.id,
          title: bib.rbo.title
      }}
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
      raise BibTeX::ParseError if @bib.errors? || @bib.empty?

      @bib.each do |rbo|
       entry = @project.bibliographiс_references.build
       entry.rbo = rbo
       entry.save
      end

    rescue BibTeX::ParseError => e
      flash[:error] = "Неверный формат библиографической записи"
  ensure
      redirect_to action: 'index'
  end

  def destroy
    @document = @project.bibliographiс_references.find(params[:id])
    @document.destroy
    redirect_to action: 'index'
  end
end