# frozen_string_literal: true

require 'date'

# BEGIN
module Model
  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(attrs = {})
    self.class.attrs_schema.each do |attr, options|
      value = attrs[attr] || options[:default]

      if !value.nil?
        value = case options[:type]
                when :integer then value.to_i
                when :string then value.to_s
                when :datetime then ::DateTime.parse(value)
                when :boolean then !!value
                else value
                end
      end
  
      self.instance_variable_set "@#{attr}", value
    end
  end

  def attributes
    instance_variables.each_with_object({}) do |var, acc|
      acc.merge!({var.to_s.sub('@', '').to_sym => self.instance_variable_get(var)})
    end
  end

  module ClassMethods
    def attribute(name, options = {})
      define_method name do
        self.instance_variable_get "@#{name}"
      end

      define_method "#{name}=" do |value|
        if !value.nil?
          val = case options[:type]
                when :integer then value.to_i
                when :string then value.to_s
                when :datetime then DateTime.parse(value)
                when :boolean then !!value
                else value
                end
        end
        
        self.instance_variable_set "@#{name}", val
      end

      add_attr_to_schema({name => options})
    end

    def add_attr_to_schema(attr)
      schema = (attrs_schema || {}).merge(attr)
      @attrs_schema = schema
      @attrs_schema
    end

    def attrs_schema
      @attrs_schema
    end
  end
end
# END
