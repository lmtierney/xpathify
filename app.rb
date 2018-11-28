require 'sinatra'
require_relative 'app/helpers/builder'
require_relative 'app/helpers/parser'

include XPathify

get '/' do
  erb :index
end

post '/xpath' do
  content_type :json
  selector = Parser.parse JSON.parse(request.body.read)
  Builder.build(selector).to_json
end
