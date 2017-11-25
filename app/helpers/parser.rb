module XPathify
  class Parser
    class << self

      def parse(array)
        data = array.inject({}) { |h, v| h[v['name']] = v['value'] unless v['value'].empty? ; h}
        hash = {}
        hash["tag_name"] = data.delete("tag_name") if data.key?("tag_name")
        hash["id"] = data.delete("id") if data.key?("id")
        hash["name"] = data.delete("name") if data.key?("name")

        data.each do |array|
          next unless array.first.include?('name')
          if array.first.include?('class')
            hash["class"] ||= []
            hash["class"] << array.last
            next
          end
          name, number = array.first.match(/(.*?)name(\d+)/).to_a[1..-1]
          matching = data.keys.find do |key|
            key[/#{name}(value|bool)#{number}/] && !data[key].empty?
          end
          value = matching.include?('bool') ? eval(data[matching]) : data[matching]
          hash[array.last] = value
        end
        hash
      end
    end
  end
end