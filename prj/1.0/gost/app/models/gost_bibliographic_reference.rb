class GostBibliographicReference < ActiveRecord::Base
  belongs_to :project

  attr_accessor :rbo

  before_save do
    self.text = self.rbo.to_s
  end

  def to_s
    text
  end

  def self.uspd
    BibTeX.open("#{Rails.root}/plugins/gost/config/data/gost.bib")
  end

  def self.get(project)
    bibs = GostBibliographicReference.uspd
    GostBibliographicReference.where(project_id: project.id).all.each do |e| #fixme
      bibs << BibTeX::Entry.parse(e.text)
    end
    bibs
  end


end