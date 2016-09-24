# encoding: utf-8
module GostDocumentsHelper

  def section_breadcrumbs(page)
    breadcrumbs = [page.title]
    page = page.parent
    while page.class != GostDocument
      breadcrumbs.unshift link_to(page.title, edit_project_gost_document_section_path(@project, @document, page)) + " » "
      page = page.parent
    end
    breadcrumbs.unshift (link_to page.title, [@project, page]) + " » "
    raw breadcrumbs.join
  end
end
