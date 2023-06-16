# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let!(:users) { create_list(:user, 5) }

  path 'api/v1/users' do
    get 'Returns all users' do
      tags 'Users'

      produces 'application/json'

      response 200, 'Users are returned successfully' do
        schema data: ['#/components/schemas/UserIndex']

        perform_request! do |response|
          data = Oj.load(response.body)['data']

          expect(data.count).to eq(5)
          expect(data.pluck('id')).to match_array(users.pluck(:id))
        end
      end
    end
  end
end
