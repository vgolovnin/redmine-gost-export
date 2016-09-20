resources :projects do
   resources :signers
   resource :gost_info, controller: 'gost_info', only: [:edit, :update]
   resources :macros, controller: 'gost_macros'
   resources :bibliography, controller: 'gost_bibliography'
   resources :gost_documents do
     resources :sections, only: [:edit, :update] do
       resource :duplicate, controller: 'section_duplicates', only: [:new, :create, :destroy]
     end
     member do
        get 'export'
      end
    end
end