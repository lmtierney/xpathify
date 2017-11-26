require 'spec_helper'

module XPathify
  describe Builder do
    it "tag_name and attribute" do
      selector = {"tag_name" => "div", "foo" => "bar"}
      expect(Builder.build(selector)).to eq ".//div[@foo='bar']"
    end

    it "id and attribute" do
      selector = {"id" => "foo", "foo" => "bar"}
      expect(Builder.build(selector)).to eq ".//*[@id='foo' and @foo='bar']"
    end

    it "name and attribute" do
      selector = {"name" => "foo", "foo" => "bar"}
      expect(Builder.build(selector)).to eq ".//*[@name='foo' and @foo='bar']"
    end

    it 'builds xpath for single attribute' do
      selector = {"foo" => 'bar'}
      expect(Builder.build(selector)).to eq ".//*[@foo='bar']"
    end

    it 'builds xpath for multiple attributes' do
      selector = {"foo" => "bar", "foo2" => "bar2", "foobar" => "barfoo"}
      expect(Builder.build(selector)).to eq ".//*[@foo='bar' and @foo2='bar2' and @foobar='barfoo']"
    end

    it 'builds xpath for boolean attributes' do
      selector = {"foo" => true, "bar" => false}
      expect(Builder.build(selector)).to eq ".//*[@foo and not(@bar)]"
    end

    it 'builds xpath for boolean and value attributes' do
      selector = {"foo" => "bar", "foobar" => true}
      expect(Builder.build(selector)).to eq ".//*[@foo='bar' and @foobar]"
    end

    it "multiple classes" do
      selector = {"class" => ['foo', 'bar-bar']}
      result = ".//*[(contains(concat(' ', @class, ' '), ' foo ') and contains(concat(' ', @class, ' '), ' bar-bar '))]"
      expect(Builder.build(selector)).to eq result
    end

    it "positive and negative classes" do
      selector = {"class" => ['foo', '!bar', 'foobar']}
      result = ".//*[(contains(concat(' ', @class, ' '), ' foo ') and not(contains(concat(' ', @class, ' '), ' bar ')) and contains(concat(' ', @class, ' '), ' foobar '))]"
      expect(Builder.build(selector)).to eq result
    end

    it "text" do
      selector = {"tag_name"=>"div", "text" => "This is my text"}
      result = ".//div[normalize-space()='This is my text']"
      expect(Builder.build(selector)).to eq result
    end
  end
end
