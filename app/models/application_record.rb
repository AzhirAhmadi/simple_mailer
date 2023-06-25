# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.validates(*attributes)
    options = attributes.extract_options!

    super(*attributes, options)
    validates_with(JsonFormatValidator, _merge_attributes(attributes)) if options[:json_format]
  end
end
