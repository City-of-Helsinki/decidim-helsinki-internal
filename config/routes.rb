# frozen_string_literal: true

# Remove after the comments refactor is merged to the core.
Decidim::Comments::Engine.routes.prepend do
  resources :comments, only: [:index, :create] do
    resources :votes, only: [:create]
  end
end

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount Decidim::Comments::Engine, at: "/", as: "decidim_comments"

  scope module: "helsinki" do
    namespace :geocoding do
      get :autocomplete
    end
  end

  Rails.application.config.static_content_pages.each do |identifier, page|
    get page[:path], to: "content_pages#show", defaults: { id: identifier }
  end

  resources :results, only: [:index, :show], controller: "decidim/accountability/directory/results", format: :html
  resources :posts, only: [:index], controller: "decidim/blogs/directory/posts", format: :html
  resources :infos, only: [:index, :show], controller: "decidim/pages", format: :html

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
