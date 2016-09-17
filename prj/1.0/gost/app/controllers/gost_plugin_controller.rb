class GostPluginController < ApplicationController
  menu_item :gost_documents
  before_action :find_project_by_project_id
#  rescue_from (ActiveRecord::RecordNotFound) {|e| render_404}
end
