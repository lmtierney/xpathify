require 'spec_helper'

module XPathify
  describe Parser do
    it 'parses general values' do
      array = [{"name" => "tag_name", "value" => "div"},
               {"name" => "id", "value" => "foid"},
               {"name" => "name", "value" => "foname"},
               {"name" => "attrtype", "value" => "value"},
               {"name" => "attrname", "value" => ""},
               {"name" => "attrvalue", "value" => ""}]
      hash = {"tag_name" => "div", "id" => "foid", "name" => "foname"}
      expect(Parser.parse(array)).to eq hash
    end

    it "parses data for multiple value attributes" do
      array = [{"name" => "attrtype", "value" => "value"},
               {"name" => "attrname", "value" => ""},
               {"name" => "attrvalue", "value" => ""},
               {"name" => "attrtype1", "value" => "value"},
               {"name" => "attrname1", "value" => "foo"},
               {"name" => "attrvalue1", "value" => "bar"},
               {"name" => "attrtype3", "value" => "value"},
               {"name" => "attrname2", "value" => "foo2"},
               {"name" => "attrvalue2", "value" => "bar2"},
               {"name" => "attrtype3", "value" => "value"},
               {"name" => "attrname3", "value" => "foobar"},
               {"name" => "attrvalue3", "value" => "barfoo"}]
      expect(Parser.parse(array)).to eq("foo" => "bar", "foo2" => "bar2", "foobar" => "barfoo")
    end

    it "parses data for booleans" do
      array = [{"name" => "attrtype", "value" => "value"},
               {"name" => "attrname", "value" => ""},
               {"name" => "attrvalue", "value" => ""},
               {"name" => "attrtype1", "value" => "exist"},
               {"name" => "attrname1", "value" => "foo"},
               {"name" => "attrbool1", "value" => "false"},
               {"name" => "attrvalue1", "value" => ""},
               {"name" => "attrtype2", "value" => "exist"},
               {"name" => "attrname2", "value" => "bar"},
               {"name" => "attrbool2", "value" => "true"},
               {"name" => "attrvalue2", "value" => ""}]

      expect(Parser.parse(array)).to eq("foo" => false, "bar" => true)
    end

    it "parses mix of attribute and boolean" do
      array = [{"name" => "attrtype", "value" => "value"},
               {"name" => "attrname", "value" => ""},
               {"name" => "attrvalue", "value" => ""},
               {"name" => "attrtype1", "value" => "value"},
               {"name" => "attrname1", "value" => "foo"},
               {"name" => "attrvalue1", "value" => "bar"},
               {"name" => "attrtype2", "value" => "exist"},
               {"name" => "attrname2", "value" => "foobar"},
               {"name" => "attrbool2", "value" => "true"},
               {"name" => "attrvalue2", "value" => ""}]

      expect(Parser.parse(array)).to eq("foo" => "bar", "foobar" => true)
    end

    it "parses multiple classes" do
      array = [{"name" => "tag_name","value" => ""},
               {"name" => "id","value" => ""},
               {"name" => "name","value" => ""},
               {"name" => "classname","value" => ""},
               {"name" => "classname2","value" => "foo"},
               {"name" => "classname3","value" => "bar-bar"},
               {"name" => "attrtype","value" => "value"},
               {"name" => "attrname","value" => ""},
               {"name" => "attrvalue","value" => ""},
               {"name" => "attrtype1","value" => "value"},
               {"name" => "attrname1","value" => ""},
               {"name" => "attrvalue1","value" => ""}]

      expect(Parser.parse(array)).to eq("class" => ['foo', 'bar-bar'])
    end

    it "parses positive and negative classes" do
      array = [{"name" => "tag_name","value" => ""},
               {"name" => "id","value" => ""},
               {"name" => "name","value" => ""},
               {"name" => "classpresent","value" => "present"},
               {"name" => "classname","value" => ""},
               {"name" => "classpresent2","value" => "present"},
               {"name" => "classname2","value" => "foo"},
               {"name" => "classpresent3","value" => "absent"},
               {"name" => "classname3","value" => "bar"},
               {"name" => "classpresent4","value" => "present"},
               {"name" => "classname4","value" => "foobar"},
               {"name" => "attrtype","value" => "value"},
               {"name" => "attrname","value" => ""},
               {"name" => "attrvalue","value" => ""},
               {"name" => "attrtype1","value" => "value"},
               {"name" => "attrname1","value" => ""},
               {"name" => "attrvalue1","value" => ""}]

      result = {"class" => ['foo', '!bar', 'foobar']}
      expect(Parser.parse(array)).to eq(result)
    end

    it "text" do
      array = [{"name" => "tag_name","value" => "div"},
               {"name" => "id","value" => ""},
               {"name" => "name","value" => ""},
               {"name" => "text","value" => "This is my text"},
               {"name" => "classpresent","value" => "present"},
               {"name" => "classname","value" => ""},
               {"name" => "attrtype","value" => "value"},
               {"name" => "attrname","value" => ""},
               {"name" => "attrvalue","value" => ""}]


      result = {"tag_name"=>"div", "text" => "This is my text"}
      expect(Parser.parse(array)).to eq(result)
    end
  end
end
