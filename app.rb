require 'sinatra'

get '/' do
  erb :index
end

post '/xpath' do
  content_type 'application/json'
  selector = params['selector']
  {xpath: selector}.to_json
end