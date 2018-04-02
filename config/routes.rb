Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', :to => 'home#index', :as => :index
  get '/login', :to => 'auth#login_form'
  post '/login', :to => 'auth#login'
  delete '/logout', :to => 'auth#logout'

  resources :course_modules do
    resources :coursework do
      nested do
        scope 'chatbot' do
          get '/', :to => 'chatbot#index'
          get '/find_answer', :to => 'chatbot#find_answer'
          resources :faq
        end
      end
    end
  end
end
