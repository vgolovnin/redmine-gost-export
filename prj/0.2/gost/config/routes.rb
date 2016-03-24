# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/projects/:id/gost', :to => 'gost#index'

get '/projects/:id/gost/:page_id/export', :to => 'gost#export'