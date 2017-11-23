require 'sinatra'
require_relative 'app/helpers/builder'

include XPathify

get '/' do
  erb :index
end

post '/xpath' do
  content_type :json
  data = JSON.parse(request.body.read)
  selectors = data.inject({}) { |h, v| h[v['name']] = v['value']; h}
  kv = {selectors['attrname1'] => selectors['attrvalue1']}
  Builder.build(kv).to_json
end
