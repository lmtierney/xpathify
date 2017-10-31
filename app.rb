require 'sinatra'

get '/' do
  erb :index
end

post '/xpath' do
  content_type :json
  data = JSON.parse(request.body.read)
  selector = data['selector']
  {xpath: selector}.to_json
end