# frozen_string_literal: true

require 'active_model'
require 'oj'

class JsonFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.errors.any? { |e| e.attribute == attribute && e.type == :json_format }

    json = Oj.load(value)
    return if json.is_a?(Hash) || json.is_a?(Array)

    record.errors.add(attribute, :json_format, message: 'is not a valid JSON object or array')
  rescue StandardError
    record.errors.add(attribute, :json_format, message: 'is not a valid JSON string')
  end
end
