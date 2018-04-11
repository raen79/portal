Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', :to => 'course_modules#index', :as => :index
  get '/login', :to => 'auth#login_form'
  post '/login', :to => 'auth#login'
  delete '/logout', :to => 'auth#logout'

  resources :course_modules, :except => [:show, :edit, :new] do
    get '/', :to  => 'course_modules#index'
    
    resources :courseworks, :except => [:show, :edit, :new] do
      get '/', :to => 'courseworks#index'

      nested do
        scope 'chatbot', :as => 'chatbot' do
          get '/', :to => 'chatbot#index'
          get '/find_answer', :to => 'chatbot#find_answer'
          get '/greet', :to => 'chatbot#greet'
          get '/new_question', :to => 'chatbot#new_question'
          
          resources :faqs, :except => [:show, :edit, :new] do
            get '/', :to => 'faqs#index'
          end
        end
      end
    end
  end
end
