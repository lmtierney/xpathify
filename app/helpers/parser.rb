module XPathify
  class Parser
    class << self

      def parse(array)
        data = array.inject({}) { |h, v| h[v['name']] = v['value'] unless v['value'].empty? ; h}
        data.each_with_object({}) do |array, hash|
          next unless array.first.include?('name')
          name, number = array.first.match(/(.*?)name(\d+)/).to_a[1..-1]
          matching = data.keys.find do |key|
            key[/#{name}(value|bool)#{number}/] && !data[key].empty?
          end
          value = matching.include?('bool') ? eval(data[matching]) : data[matching]
          hash[array.last] = value
        end

      end
    end
  end
end