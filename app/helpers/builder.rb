module XPathify
  class Builder
    UPPERCASE_LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ'.freeze
    LOWERCASE_LETTERS = 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ'.freeze
    LITERAL_REGEXP = /\A([^\[\]\\^$.|?*+()]*)\z/

    def build(selector)
      @selector = selector

      @selector.keys.each { |key| @selector[key.to_sym] = @selector.delete(key) }

      index = @selector.delete(:index)
      @adjacent = @selector.delete(:adjacent)

      xpath = start_string
      xpath << adjacent_string
      xpath << tag_string
      xpath << class_string
      xpath << text_string
      xpath << attribute_string

      index ? add_index(xpath, index) : xpath
    end

    private

    def process_attribute(key, value)
      if value.is_a? Regexp
        predicate_conversion(key, value)
      else
        predicate_expression(key, value)
      end
    end

    def predicate_expression(key, val)
      if val.eql? true
        attribute_presence(key)
      elsif val.eql? false
        attribute_absence(key)
      else
        equal_pair(key, val)
      end
    end

    def predicate_conversion(key, regexp)
      # type attributes can be upper case - downcase them
      # https://github.com/watir/watir/issues/72
      downcase = key == :type || regexp.casefold?

      lhs = lhs_for(key, downcase)

      if simple_regexp?
        "contains(#{lhs}, '#{regexp.source}')"
      elsif regexp.source[0] == '^' && simple_regexp?(regexp.source[1..-1])
        "starts-with(#{lhs}, '#{regexp.source[1..-1]}')"
      else
        raise "Unable to build XPath from #{key} => #{regexp}"
      end
    end

    def start_string
      @adjacent ? './' : './/*'
    end

    def adjacent_string
      case @adjacent
      when nil
        ''
      when :ancestor
        'ancestor::*'
      when :preceding
        'preceding-sibling::*'
      when :following
        'following-sibling::*'
      when :child
        'child::*'
      else
        raise "Unable to process adjacent locator with #{@adjacent}"
      end
    end

    def tag_string
      tag_name = @selector.delete(:tag_name)
      tag_name.nil? ? '' : "[#{process_attribute(:tag_name, tag_name)}]"
    end

    def class_string
      class_name = @selector.delete(:class)
      return '' if class_name.nil?

      predicates = [class_name].flatten.map {|value| process_attribute(:class, value)}.compact

      predicates.empty? ? '' : "[#{predicates.join(' and ')}]"
    end

    def text_string
      text = @selector.delete :text
      return '' if text.nil?

      "[#{predicate_expression(:text, text)}]"
    end

    def attribute_string
      attributes = @selector.keys.map {|key|
        process_attribute(key, @selector.delete(key))
      }.flatten.compact
      attributes.empty? ? '' : "[#{attributes.join(' and ')}]"
    end

    def add_index(xpath, index)
      if @adjacent
        "#{xpath}[#{index + 1}]"
      elsif index&.positive?
        "(#{xpath})[#{index + 1}]"
      elsif index&.negative?
        last_value = 'last()'
        last_value << (index + 1).to_s if index < -1
        "(#{xpath})[#{last_value}]"
      else
        xpath
      end
    end

    def simple_regexp?(regex)
      return false if !regex.is_a?(Regexp) || regex.casefold? || regex.source.empty?

      regex.source =~ LITERAL_REGEXP
    end

    def requires_matching?(results, regexp)
      regexp.casefold? ? !results.first.casecmp(regexp.source).zero? : results.first != regexp.source
    end

    def lhs_for(key, downcase = false)
      case key
      when String
        "@#{key}"
      when :tag_name
        'local-name()'
      when :href
        'normalize-space(@href)'
      when :text
        'normalize-space()'
      when :contains_text
        'text()'
      when ::Symbol
        lhs = "@#{key.to_s.tr('_', '-')}"
        downcase ? downcase(lhs) : lhs
      else
        raise "Unable to build XPath using #{key}:#{key.class}"
      end
    end

    def attribute_presence(attribute)
      lhs_for(attribute, false)
    end

    def attribute_absence(attribute)
      lhs = lhs_for(attribute, false)
      "not(#{lhs})"
    end

    def equal_pair(key, value)
      if key == :class
        negate_xpath = value =~ /^!/ && value.slice!(0)
        expression = "contains(concat(' ', @class, ' '), #{escape " #{value} "})"

        negate_xpath ? "not(#{expression})" : expression
      else
        "#{lhs_for(key, key == :type)}=#{escape value}"
      end
    end

    def escape(value)
      if value.include? "'"
        parts = value.split("'", -1).map {|part| "'#{part}'"}
        string = parts.join(%(,"'",))

        "concat(#{string})"
      else
        "'#{value}'"
      end
    end

    def downcase(value)
      "translate(#{value},'#{UPPERCASE_LETTERS}','#{LOWERCASE_LETTERS}')"
    end
  end
end