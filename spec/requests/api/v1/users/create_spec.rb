# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  path 'api/v1/users' do
    post 'Creates a user' do
      tags 'Users'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            required: %i(email credential_data),
            properties: {
              email: {
                type: :string
              },
              credential_data: {
                type: :string
              }
            }
          }
        }
      }

      response 201, 'User is created successfully' do
        let(:payload) do
          {
            data: {
              email: 'email@test.com',
              credential_data: {
                imap: { key1: 'value1' },
                smtp: { key1: 'value1' }
              }.to_json
            }
          }
        end

        schema data: '#/components/schemas/UserShow'

        perform_request! do
          user = User.last
          data = Oj.load(response.body, symbol_keys: true)[:data]

          expect(user.email).to eq('email@test.com')
          expect(user.credential_data).to eq(payload[:data][:credential_data])
          expect(data[:id]).to eq(user.id)
        end
      end

      response 422, 'User is not created if email is invalid' do
        let(:payload) do
          {
            data: {
              email: 'invalid_email',
              credential_data: {
                imap: { key1: 'value1' },
                smtp: { key1: 'value1' }
              }.to_json
            }
          }
        end

        schema data: '#/components/schemas/Error'

        perform_request! do
          data = Oj.load(response.body, symbol_keys: true)[:error]

          expect(data[:message]).to eq('Validation failed: Email is invalid')
        end
      end
    end
  end
end
