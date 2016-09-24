class GostDocument < ActiveRecord::Base
  belongs_to :project
  has_many :sections, as: :parent, dependent: :destroy
  accepts_nested_attributes_for :sections, allow_destroy: true


  def nested_section(id)
    section = Section.find(id)

    elem = section
    loop do
      break if elem.parent_type == 'GostDocument'
      elem = elem.parent
    end

    elem.parent.id == self.id ? section : nil

  end

  def use_template(template)
    self.title = template['name']
    self.document_code = template['document_code']
    self.document_gost = template['document_gost']
    self.description = template['description']
    self.has_annotation = template['has_annotation']
    self.has_changeslist = template['has_annotation']
    self.sections = Section.load_sections(template['sections'])
    self
  end


  def self.templates
    @templates ||= YAML.load_file("#{Rails.root}/plugins/gost/config/data/documents_templates.yml")['templates']
  end

end
