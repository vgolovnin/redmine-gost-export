class GostPluginController < ApplicationController
  before_action :find_project_by_project_id
  rescue_from (ActiveRecord::RecordNotFound) {|e| render_404}
end
