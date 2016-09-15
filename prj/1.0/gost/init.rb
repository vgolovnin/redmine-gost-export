Redmine::Plugin.register :gost do
  name 'Gost Export Plugin'
  author 'Victor Golovnin'
  description 'This is a GOST documentation plugin for Redmine'
  version '1.0.0'


  project_module :gost do
    permission :gost_view, {
        gost_documents: [:index, :export, :show],
        gost_bibliography: [:index]
    }
    permission :gost_edit, {
        gost_documents: [:new, :create, :edit, :update, :destroy],
        gost_info: [:edit, :update],
        gost_bibliography: [:new, :create, :destroy]
    }
  end
  menu :project_menu, :gost, {controller: 'gost_documents', action: 'index'}, caption: 'Документация ГОСТ', param: :project_id

  module ProjectGostPatch
    def self.included(base)
      base.class_eval do
        unloadable
        has_one :gost_info
        has_many :gost_documents
        has_many :bibliographiс_references, class_name: 'GostBibliographicReference'
      end
    end
  end

  Project.send(:include, ProjectGostPatch)

  require 'RedCloth'
  require 'bibtex'
  require 'latex_build'
end