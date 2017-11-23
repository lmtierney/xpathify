require_relative '../../app/helpers/builder'
require_relative '../../app/helpers/parser'

require 'rspec'

module XPathify
  describe Parser do
    it "builds xpath for multiple attributes" do
      array = [{"name" => "attrname1", "value" => "foo"},
              {"name" => "attrvalue1", "value" => "bar"},
              {"name" => "attrname2", "value" => "foo2"},
              {"name" => "attrvalue2", "value" => "bar2"},
              {"name" => "attrname3", "value" => "foobar"},
              {"name" => "attrvalue3", "value" => "barfoo"}]

      expect(Parser.parse(array)).to eq("foo"=>"bar", "foo2"=>"bar2", "foobar"=>"barfoo")
    end
  end


  describe Builder do
    it 'builds xpath for single attribute' do
      selector = {foo: 'bar'}
      expect(Builder.build(selector)).to eq ".//*[@foo='bar']"
    end

    it 'builds xpath for multiple attributes' do
      selector = {"foo"=>"bar", "foo2"=>"bar2", "foobar"=>"barfoo"}
      expect(Builder.build(selector)).to eq ".//*[@foo='bar' and @foo2='bar2' and @foobar='barfoo']"
    end
  end
end
