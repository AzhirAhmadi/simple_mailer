# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mail::SmtpSender, type: :service do
  subject { described_class.call(**attributes) }

  let(:user) { create(:user, credential_data: credential_data) }
  let(:credential_data) do
    {
      url: 'smtp.domain.com',
      port: 587,
      domain: 'domain.com',
      user_name: 'user_email',
      password: 'user_password'
    }
  end

  let(:attributes) do
    {
      credentials: credential_data,
      to: 'to@test.com',
      cc: ['cc1@test.com', 'cc2@test.com'],
      bcc: ['bcc1@test.com', 'bcc2@test.com'],
      subject: 'subject',
      body: 'body'
    }
  end

  let(:smtp) { Net::SMTP.new('smtp.gmail.com', 587) }

  before do
    allow(Net::SMTP).to receive(:new).and_return(smtp)
    allow(smtp).to receive(:start).and_return(true)
    allow(smtp).to receive(:send_message).and_return(true)
    allow(smtp).to receive(:finish).and_return(true)
  end

  describe '#call' do
    context 'when correct attributes are provided' do
      it { is_expected.to be_success }

      it 'calls Net::SMTP.new' do
        subject

        expect(Net::SMTP).to have_received(:new).with('smtp.domain.com', 587)
      end

      it 'calls smtp.start' do
        subject

        expect(smtp).to have_received(:start).with(
          'domain.com',
            'user_email',
            'user_password',
          :login
        )
      end

      it 'calls smtp.send_message' do
        subject

        message = <<~EMAIL
          Subject: subject
          To: to@test.com
          CC: cc1@test.com,cc2@test.com
          BCC: bcc1@test.com,bcc2@test.com

          body
        EMAIL

        expect(smtp).to have_received(:send_message).with(
          message,
          'user_email',
          'to@test.com',
          ['cc1@test.com', 'cc2@test.com', 'bcc1@test.com', 'bcc2@test.com']
        )
      end
    end

    context 'when fields are not provided' do
      context 'for credentials' do
        let(:attributes) { super().except(:credentials) }

        it 'raises KeyError error' do
          expect { subject }.to raise_error(KeyError, /option 'credentials'/)
        end
      end

      context 'for to' do
        let(:attributes) { super().except(:to) }

        it 'raises KeyError error' do
          expect { subject }.to raise_error(KeyError, /option 'to'/)
        end
      end

      context 'for body' do
        let(:attributes) { super().except(:body) }

        it 'raises KeyError error' do
          expect { subject }.to raise_error(KeyError, /option 'body'/)
        end
      end
    end
  end
end
