Redmine::Plugin.register :gost do
  name 'Gost plugin'
  author 'Victor Golovnin'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'


  BUILD_DIR = Rails.root.to_s + "/plugins/gost/lib/build"
  permission :gost, { :gost => [:index] }, :public => true
  menu :project_menu, :gost, {:controller => 'gost', :action => 'index'}, :caption => 'GOST EXPORT'
end

require 'gost_formatter'
require 'latex_build'
#Redmine::WikiFormatting::Textile::Formatter.send(:include, LatexFormatter)