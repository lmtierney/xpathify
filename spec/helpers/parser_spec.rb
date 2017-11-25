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
  end
end
