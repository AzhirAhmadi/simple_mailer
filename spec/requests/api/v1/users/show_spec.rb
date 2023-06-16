# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  before do
    create_list(:user, 5)
  end

  let!(:user) { User.first }

  path 'api/v1/users/{id}' do
    get 'Returns the user' do
      tags 'Users'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      let(:id) { user.id }

      response 200, 'User is returned successfully' do
        schema data: '#/components/schemas/UserShow'

        perform_request! do |response|
          data = Oj.load(response.body, symbol_keys: true)[:data]

          expect(data[:id]).to eq(user.id)
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
