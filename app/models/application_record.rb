class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.camel_case(*attr_names)
    attr_names.each do |attr_name|
      tokens = attr_name.to_s.split("_")
      camel_case = tokens.shift
      tokens.each { |token| camel_case += token.capitalize }

      define_method camel_case do
        send attr_name
      end
      define_method "#{camel_case}=" do |value|
        send "#{attr_name}=", value
      end
    end
  end
end
