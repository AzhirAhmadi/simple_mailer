# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mail::Imap::SyncMailKeys, type: :service do
  subject { described_class.call(**attributes) }

  let(:user) { create(:user) }

  let(:attributes) do
    {
      user: user
    }
  end

  describe '#call' do
    context 'when user is provided' do
      before do
        allow(Mail::Imap::FetchInboxSubjects).to receive(:call)
          .and_return(Dry::Monads::Success(fetch_inbox_subjects_result))
      end

      context 'for existing mail keys' do
        let(:fetch_inbox_subjects_result) do
          [
            { message_id: 1, subject: 'new_subject_1' },
            { message_id: 2, subject: 'new_subject_2' }
          ]
        end

        before do
          create(:mail_key, user_id: user.id, message_id: 1, subject: 'subject_1')
          create(:mail_key, user_id: user.id, message_id: 2, subject: 'subject_2')
        end

        it 'updates existing mail keys\'s subject' do
          subject

          expect(MailKey.all.pluck(:subject)).to match_array(
            %w(new_subject_1 new_subject_2)
          )
        end

        it 'does not create mail kyes' do
          expect { subject }.not_to change(MailKey, :count)
        end
      end

      context 'for new mail keys' do
        let(:fetch_inbox_subjects_result) do
          [
            { message_id: 1, subject: 'subject_1' },
            { message_id: 2, subject: 'subject_2' }
          ]
        end

        it 'updates existing mail keys\'s subject' do
          subject

          expect(MailKey.all.pluck(:subject)).to match_array(
            %w(subject_1 subject_2)
          )
        end

        it 'creates new mail keys' do
          expect { subject }.to change(MailKey, :count).by(2)
        end
      end

      context 'for old mail keys' do
        let(:fetch_inbox_subjects_result) { [] }

        before do
          create(:mail_key, user_id: user.id, message_id: 1, subject: 'subject_1')
          create(:mail_key, user_id: user.id, message_id: 2, subject: 'subject_2')
        end

        it 'deletes old mail keys' do
          expect { subject }.to change(MailKey, :count).by(-2)
        end
      end
    end
  end
end
