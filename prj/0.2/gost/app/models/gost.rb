class Gost

  def initialize(project)
    @project = project
    @pages = @project.wiki.pages.to_a.map {|page| GostExportExtension::TextileDocGost.new(page) }
  end

  def pages
    @pages.select {|page| page.gost_template?}
  end

  def definitions
    @pages.select {|page| page.gost_definitions?}
  end

  def bibliographies
    @pages.select {|page| page.gost_bibliography?}.map {|page| {page.title => page.extract_bibliography} }.inject(:update)
  end

  def extract_definitions
    self.definitions.each {|page| page.extract_definitions}
  end


  def page(title)
    GostExportExtension::TextileDocGost.new( @project.wiki.pages.find_by title: title)
  end

end