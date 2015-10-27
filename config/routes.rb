StyleGuide::Engine.routes.draw do
  root :to => 'style#index'
  get '/partial' => 'style#partial', as: :partial
  get '/:id' => 'style#show', as: :style
end
