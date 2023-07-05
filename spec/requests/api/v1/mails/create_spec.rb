# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::MailsController, type: :request do
  let(:user) { create(:user, credential_data: credential_data.to_json) }
  let(:credential_data) do
    {
      smtp: {
        url: 'smtp.domain.com',
        port: 587,
        domain: 'domain.com',
        user_name: 'user_email',
        password: 'user_password'
      }
    }
  end

  before do
    smtp_result = Net::SMTP::Response.new('250', 'OK')
    allow(Mail::SmtpSender).to receive(:call).and_return(Dry::Monads::Success(smtp_result))
  end

  path 'api/v1/users/{user_id}/mails/' do
    post 'Sends an email' do
      tags 'Emails'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id, in: :path, type: :string
      let(:user_id) { user.id }

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            required: %i(to cc bcc subject body),
            properties: {
              to: { type: :string },
              cc: { type: :string },
              bcc: { type: :string },
              subject: { type: :string },
              body: { type: :string }
            }
          }
        }
      }

      let(:payload) do
        {
          data: {
            to: 'to@test.com',
            cc: ['cc1@test.com', 'cc2@test.com'],
            bcc: ['bcc1@test.com', 'bcc2@test.com'],
            subject: 'subject',
            body: 'body'
          }
        }
      end

      response 201, 'Email is sent successfully' do
        perform_request! do
          expect(Mail::SmtpSender).to have_received(:call).with(
            credentials: credential_data[:smtp],
            to: 'to@test.com',
            cc: ['cc1@test.com', 'cc2@test.com'],
            bcc: ['bcc1@test.com', 'bcc2@test.com'],
            subject: 'subject',
            body: 'body'
          )
        end
      end
    end
  end
end
