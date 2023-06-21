# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::MailKeysController, type: :request do
  let(:user) { create(:user) }
  let!(:mail_keys) { create_list(:mail_key, 5, user_id: user.id) }

  path 'api/v1/users/{user_id}/mail_keys' do
    get 'Returns all mail_keys' do
      tags 'MailKeys'

      produces 'application/json'

      parameter name: :user_id, in: :path, type: :string
      let(:user_id) { user.id }

      response 200, 'Mail keys are returned successfully' do
        schema data: ['#/components/schemas/MailKey']

        perform_request! do |response|
          data = Oj.load(response.body)['data']

          expect(data.count).to eq(5)
          expect(data.pluck('id')).to match_array(mail_keys.pluck(:id))
        end
      end
    end
  end
end
