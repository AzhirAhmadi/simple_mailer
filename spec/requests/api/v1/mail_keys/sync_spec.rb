# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::MailKeysController, type: :request do
  let(:user) { create(:user) }
  let(:fetch_inbox_subjects_result) do
    [
      { message_id: '1', subject: 'new_subject_1' },
      { message_id: '2', subject: 'new_subject_2' },
      { message_id: '3', subject: 'new_subject_3' },
      { message_id: '4', subject: 'new_subject_4' },
      { message_id: '5', subject: 'new_subject_5' }
    ]
  end
  let!(:mail_keys) { create_list(:mail_key, 5, user_id: user.id) }

  before do
    allow(Mail::FetchInboxSubjects).to receive(:call)
      .and_return(Dry::Monads::Success(fetch_inbox_subjects_result))
  end

  path 'api/v1/users/{user_id}/mail_keys/sync' do
    get 'Sync all mail_keys with user\'s mail box' do
      tags 'MailKeys'

      produces 'application/json'

      parameter name: :user_id, in: :path, type: :string
      let(:user_id) { user.id }

      response 200, 'Mail keys are synced successfully' do
        perform_request! do
          expect(MailKey.count).to eq(5)
        end
      end
    end
  end
end
