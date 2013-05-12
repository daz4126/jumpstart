$:.unshift(File.expand_path('../../lib', __FILE__))

require 'sinatra/base'
require 'slim'
require 'sass'
require 'coffee-script'
require 'v8'
require 'sinatra/auth'
require 'sinatra/contact'
require 'sinatra/flash'
require 'sinatra/reloader'
require 'asset-handler'

class ApplicationController < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  helpers ApplicationHelpers

  set :views, File.expand_path('../../views', __FILE__)
  enable :sessions, :method_override

  register Sinatra::Auth
  register Sinatra::Contact
  register Sinatra::Flash

  use AssetHandler

  not_found{ slim :not_found }
end
