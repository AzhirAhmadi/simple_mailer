# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let!(:user) do
    create(
      :user,
      email: 'email@test.com',
      credential_data: { key1: 'value1' }.to_json
    )
  end

  path 'api/v1/users/{id}' do
    put 'Updates the user' do
      tags 'Users'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      let(:id) { user.id }

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
      let(:payload) do
        {
          data: {
            email: 'new_email@test.com',
            credential_data: { key2: 'value2' }.to_json
          }
        }
      end

      response 200, 'User is updated successfully' do
        schema data: '#/components/schemas/UserShow'

        perform_request! do |response|
          data = Oj.load(response.body, symbol_keys: true)[:data]
          user.reload

          expect(data[:id]).to eq(user.id)
          expect(data[:email]).to eq('new_email@test.com')
          expect(user.credential_data).to eq({ key2: 'value2' }.to_json)
        end
      end

      response 404, 'User not found' do
        let(:id) { 'invalid' }

        schema error: '#/components/schemas/Error'

        perform_request! do |response|
          error = Oj.load(response.body, symbol_keys: true)[:error]

          expect(error[:message]).to eq('Record not found')
        end
      end

      response 422, 'User is not updated if email is invalid' do
        let(:payload) do
          super().tap { |payload| payload[:data][:email] = 'invalid_email' }
        end

        schema error: '#/components/schemas/Error'

        perform_request! do |response|
          error = Oj.load(response.body, symbol_keys: true)[:error]

          expect(error[:message]).to eq('Validation failed: Email is invalid')
        end
      end
    end
  end
end
