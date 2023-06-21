# frozen_string_literal: true

Swagger.define do
  schema 'Mail', {
    type: :object,
    required: %i(
      from
      to
      subject
      body
    ),
    properties: {
      from: {
        type: :string
      },
      to: {
        type: :string
      },
      subject: {
        type: :string
      },
      body: {
        type: :string
      }
    }
  }
end
