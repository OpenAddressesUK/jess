require 'sinatra/base'

class Jess < Sinatra::Base
  get '/' do
    'Hello from Jess'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
