resources :projects do
   resources :signers
   resource :gost_info, controller: 'gost_info', only: [:edit, :update]
   resources :bibliography, controller: 'gost_bibliography'
   resources :gost_documents do
     resources :sections, only: [:edit, :update]
     member do
        get 'export'
      end
    end
end