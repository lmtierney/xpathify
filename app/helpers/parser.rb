module XPathify
  class Parser
    class << self

      def parse(array)
        data = array.inject({}) { |h, v| h[v['name']] = v['value']; h}
        data.each_with_object({}) do |array, hash|
          hash[array.last] = data.delete array.first.gsub('name', 'value')
        end


      end
    end
  end
end