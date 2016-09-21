resources :projects do
   resources :signers, only: [:index, :new, :create, :update, :destroy]
   get :gost_info, to: 'gost_info#edit'
   put :gost_info, to: 'gost_info#update'
   resources :macros, controller: 'gost_macros'
   resources :bibliography, controller: 'gost_bibliography'
   resources :gost_documents do
     resources :sections, only: [:new, :create, :edit, :update, :destroy] do
       resource :duplicate, controller: 'section_duplicates', only: [:new, :create, :destroy]
     end
     member do
        get 'export'
      end
    end
end