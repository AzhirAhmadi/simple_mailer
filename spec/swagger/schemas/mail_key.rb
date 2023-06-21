# frozen_string_literal: true

Swagger.define do
  schema 'MailKey', {
    type: :object,
    required: %i(
      id
      subject
    ),
    properties: {
      id: {
        type: :integer
      },
      subject: {
        type: :string
      }
    }
  }
end
