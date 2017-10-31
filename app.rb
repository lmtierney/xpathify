require 'sinatra'

get '/' do
  erb :index
end

post '/xpath' do
  content_type :json
  data = JSON.parse(request.body.read)
  selectors = data.inject({}) { |h, v| h[v['name']] = v['value']; h}
  selectors.to_json
end