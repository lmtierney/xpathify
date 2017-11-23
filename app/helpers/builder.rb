module XPathify
  class Builder
    class << self

      def build(selectors)
        xpath = ".//*"

        unless selectors.empty?
          xpath << "[" << attribute_expression(selectors) << "]"
        end

        xpath
      end

      def attribute_expression(selectors)
        f = selectors.map do |key, value|
          "#{"@#{key.to_s.tr("_", "-")}"}=#{escape value}"
        end
        f.join(" and ")
      end

      def escape(value)
        if value.include? "'"
          parts = value.split("'", -1).map { |part| "'#{part}'" }
          string = parts.join(%{,"'",})

          "concat(#{string})"
        else
          "'#{value}'"
        end
      end
    end
  end
end