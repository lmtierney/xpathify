require 'sinatra'

get '/' do
  send_file 'views/index.html'
end

post '/xpath' do
  selector = params['selector']
  {xpath: selector}.to_json
end