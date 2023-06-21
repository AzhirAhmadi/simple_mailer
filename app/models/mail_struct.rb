# frozen_string_literal: true

class MailStruct < Dry::Struct
  transform_keys(&:to_sym)

  attribute :from, Types::String
  attribute :to, Types::String
  attribute :subject, Types::String
  attribute :body, Types::String
end
