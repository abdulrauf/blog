Rails.application.routes.draw do
  scope :module => 'gluttonberg' do
    namespace :admin do
      scope :module => 'blog' do
        scope 'comments', :controller => :comments, :as => :comments do
          get 'spam_detection_for_all_pending' , :as => :spam_detection_for_all_pending
          get 'pending', :as => :pending
          get 'spam' , :as => :spam
          get 'approved' , :as => :approved
          get 'rejected' => :rejected , :as => :rejected
          get '/moderation/:id/:moderation' => :moderation , :as => :moderation
          get '/delete/:id' => :delete , :as => :delete
          delete '/destroy/:id' => :destroy , :as => :destroy
          get '/block_author/:id' => :block_author , :as => :block_author
        end

        resources :blogs do
          get 'delete', :on => :member
          resources :articles do
            member do
              get 'delete'
              get 'duplicate'
            end
            collection do
              match 'import'
              get 'export'
            end
            resources :comments do
              member do
                get 'delete'
              end
            end
          end
        end # blogs
      end #blog module
    end #admin
    scope :module => 'public' do
      # Blog Stuff
      get "/articles/tag/:tag" => "articles#tag" , :as => :articles_by_tag
      get "/articles/unsubscribe/:reference" => "articles#unsubscribe" , :as => :unsubscribe_article_comments
      scope "(/:locale)" do
        resources :blogs do
          resources :articles do
            resources :comments
            get "preview"
          end
        end
      end
    end#public
  end #gluttonberg
end
