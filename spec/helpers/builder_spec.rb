require_relative '../../app/helpers/builder'

require 'rspec'

module XPathify
  describe Builder do
    it 'builds xpath for single attribute' do
      selector = {foo: 'bar'}
      expect(Builder.build(selector)).to eq ".//*[@foo='bar']"
    end
  end
end
