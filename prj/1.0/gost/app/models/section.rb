class Section < ActiveRecord::Base

  self.table_name = 'gost_sections'
  belongs_to :parent, polymorphic: true
  has_many :sections, as: :parent, dependent: :destroy
  accepts_nested_attributes_for :sections, allow_destroy: true

  has_one :helper, class_name: 'GostHelper', dependent: :destroy

  default_scope { order(index: :asc) }

  def use_template(template, index)
    self.title = template['name']
    self.index = index
    self.description = template['description']
    if template['helper']
      self.create_helper(name: template['helper'])
    end
    self.tips = template['tips'] unless template['tips'].nil?
    self.sections = Section.load_sections(template['sections'])
    self
  end


  def self.load_sections(template)
    if template.nil? or template.empty?
      return []
    end
    sections = []
    template.each_with_index do |section, index|
      sections.push(Section.new.use_template(section, index))
    end
    sections
  end

end