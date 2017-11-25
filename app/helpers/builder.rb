module XPathify
  class Builder
    class << self

      def build(selectors)
        tag_name = selectors.delete("tag_name") || "*"
        ".//#{tag_name}#{attribute_expression(selectors)}"
      end

      private

      def attribute_expression(selectors)
        return '' if selectors.empty?
        f = selectors.map do |key, value|
          if value.is_a?(Array) && key == "class"
            "(" + value.map { |v| build_class_match(v) }.join(" and ") + ")"
          elsif value == true
            lhs(key)
          elsif value == false
            "not(#{lhs(key)})"
          else
            "#{lhs(key)}=#{escape value}"
          end
        end
        "[#{f.join(" and ")}]"
      end

      def lhs(key)
        "@#{key.to_s.tr("_", "-")}"
      end

      def build_class_match(value)
        "contains(concat(' ', @class, ' '), #{escape " #{value} "})"
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