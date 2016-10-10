class GostBibliographicReference < ActiveRecord::Base
  belongs_to :project
  attr_accessor :rbo

  before_save do
    self.text = self.rbo.to_s
  end

  after_find do
    self.rbo = BibTeX::Entry.parse(self.text)[0]
  end

  def to_s
    text
  end

  def self.uspd
    @uspd ||= BibTeX.open("#{Rails.root}/plugins/gost/config/data/gost.bib")
  end

  def self.get(project)
    bibs = GostBibliographicReference.uspd
    bibs = bibs.map do |bib|
      self.new(text: bib.to_s, rbo: bib)
    end
    GostBibliographicReference.where(project_id: project.id).all.each do |e|
      bibs << e
    end
    bibs
  end

  def self.get_bibliography(project)
    bibs = GostBibliographicReference.uspd
    GostBibliographicReference.where(project_id: project.id).all.each do |e| #fixme
      bibs << e.rbo
    end
    bibs
  end
end