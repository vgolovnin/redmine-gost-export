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
    templates = YAML.load_file("#{Rails.root}/plugins/gost/config/data/uspd_standarts.yml")['uspd']
    bibs = BibTeX::Bibliography.new
    templates.each do |template|
      bibs << BibTeX::Entry.new({
          bibtex_type: :book,
          bibtex_key: template['key'],
          title: template['title'],
          address: 'М.',
          publisher: 'ИПК Издательство стандартов',
          series: 'Единая система программной документации',
          year: '2001'
        })
    end
    bibs
  end

  def self.get(project)
    bibs = GostBibliographicReference.uspd
    GostBibliographicReference.where(project_id: project.id).all.each do |e| #fixme
      bibs << BibTeX::Entry.parse(e.text)
    end
    bibs
  end


end