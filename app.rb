require 'sinatra'
require_relative 'app/helpers/builder'
require_relative 'app/helpers/parser'

include XPathify

get '/' do
  erb :index
end

post '/xpath' do
  content_type :json
  selectors = Parser.parse JSON.parse(request.body.read)
  Builder.build(selectors).to_json
end
