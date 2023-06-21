# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::MailsController, type: :request do
  let!(:user) { create(:user) }
  let(:mail) do
    MailStruct.new(from: 'from',
                   to: 'to',
                   subject: 'subject',
                   body: 'body')
  end

  before do
    allow(Mail::Read).to receive(:call).and_return(Dry::Monads::Success(mail))
  end

  path 'api/v1/users/{user_id}/mails/{id}' do
    get 'Returns the mail' do
      tags 'Mails'

      produces 'application/json'

      parameter name: :user_id, in: :path, type: :string
      let(:user_id) { user.id }
      parameter name: :id, in: :path, type: :string
      let(:id) { 1 }

      response 200, 'Mail is returned successfully' do
        schema data: '#/components/schemas/Mail'

        perform_request! do
          expect(Mail::Read).to have_received(:call).with(
            user: user,
            message_id: 1
          )
        end
      end
    end
  end
end
