# frozen_string_literal: true

Swagger.define do
  schema 'UserShow', {
    type: :object,
    required: %i(
      id
      email
      created_at
      updated_at
    ),
    properties: {
      id: {
        type: :integer
      },
      email: {
        type: :string
      },
      created_at: {
        type: :string,
        format: :date_time
      },
      updated_at: {
        type: :string,
        format: :date_time
      }
    }
  }
end
