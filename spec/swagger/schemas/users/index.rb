# frozen_string_literal: true

Swagger.define do
  schema 'UserIndex', {
    type: :object,
    required: %i(
      id
      email
    ),
    properties: {
      id: {
        type: :integer
      },
      email: {
        type: :string
      }
    }
  }
end
