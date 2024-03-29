# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mail::Imap::Read, type: :service do
  subject { described_class.call(**attributes) }

  let(:user) { create(:user, credential_data: credential_data) }
  let(:credential_data) do
    {
      imap: {
        url: 'imap.gmail.com',
        port: 993,
        user_name: 'user_email',
        password: 'user_password'
      }
    }.to_json
  end

  let(:attributes) do
    {
      user: user,
      credential_key: 'imap',
      message_id: 1
    }
  end

  describe '#call' do
    context 'when user is provided' do
      let(:imap) { Net::IMAP.new('imap.gmail.com', port: 993, ssl: true) }
      let(:select) { Mail::Imap::Queries::Select.new(imap: imap) }
      let(:search) { Mail::Imap::Queries::Search.new(imap: imap) }
      let(:message_ids) { [1, 2, 3] }
      let(:fetch) { Mail::Imap::Queries::Fetch.new(imap: imap, message_ids: message_ids) }
      let(:imap_result_struct) { Struct.new(:seqno, :attr) }
      let(:result) do
        [
          imap_result_struct.new(1, { 'Query Code' => 'Subject: Mail Subject1' }),
          imap_result_struct.new(2, { 'Query Code' => 'Subject:' }),
          imap_result_struct.new(3, { 'Query Code' => 'Subject: Mail2  ' })
        ]
      end
      let(:email) do
        Mail.new
      end

      before do
        allow(Net::IMAP).to receive(:new).and_return(imap)
        allow(imap).to receive(:login).and_return(true)

        allow(Mail::Imap::Connection).to receive(:connect).and_return(select)
        allow(imap).to receive(:select).and_return(true)
        allow(select).to receive(:mailbox).and_return(search)

        allow(imap).to receive(:search).and_return(message_ids)
        allow(search).to receive(:search).and_return(fetch)

        allow(imap).to receive(:fetch).and_return(result)
        allow(fetch).to receive(:fetch).and_call_original

        allow(Mail).to receive(:new).and_return(email)
        allow(email).to receive(:from).and_return(['from'])
        allow(email).to receive(:to).and_return(['to'])
        allow(email).to receive(:subject).and_return('subject')
        allow(email).to receive(:body).and_return('body')
      end

      it { is_expected.to be_success }

      it 'calls Mail::Connection.connect' do
        subject

        expect(Mail::Imap::Connection).to have_received(:connect).with(
          url: 'imap.gmail.com',
          port: 993,
          user_name: 'user_email',
          password: 'user_password'
        )
      end

      it 'calls select.mailbox' do
        subject

        expect(select).to have_received(:mailbox).with(name: 'INBOX')
      end

      it 'calls search.search' do
        subject

        expect(search).to have_received(:search).with(query: 'ALL')
      end

      it 'calls fetch.fetch' do
        subject

        expect(fetch).to have_received(:fetch).with(
          query: 'BODY.PEEK[]',
          custom_message_ids: [1]
        )
      end

      it 'returns Mail of subjects' do
        expect(subject.value!).to be_a(MailStruct)
      end
    end

    context 'when user is not provided' do
      let(:attributes) { super().except(:user) }

      it 'raises KeyError error' do
        expect { subject }.to raise_error(KeyError, /option 'user'/)
      end
    end
  end
end
