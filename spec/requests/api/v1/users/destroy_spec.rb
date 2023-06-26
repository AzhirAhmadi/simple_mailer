# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let!(:user) { create(:user) }

  path 'api/v1/users/{id}' do
    delete 'Updates the user' do
      tags 'Users'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      let(:id) { user.id }

      response 200, 'User is deleted successfully' do
        schema data: '#/components/schemas/UserShow'

        perform_request! do |response|
          data = Oj.load(response.body, symbol_keys: true)[:data]

          expect(data[:id]).to eq(user.id)
          expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
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
    end
  end
end
