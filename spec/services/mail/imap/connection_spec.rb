# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mail::Imap::Connection, type: :service do
  subject { described_class.connect(**attributes) }

  let(:attributes) do
    {
      url: 'imap.gmail.com',
      port: 993,
      user_name: 'test_user',
      password: 'test_password'
    }
  end

  describe '#call' do
    context 'when fields are provided' do
      let(:imap) { Net::IMAP.new(attributes[:url], port: attributes[:port], ssl: true) }

      before do
        allow(Net::IMAP).to receive(:new).and_return(imap)
        allow(imap).to receive(:login).and_return(true)
      end

      it 'calls Net::IMAP.new' do
        subject

        expect(Net::IMAP).to have_received(:new).with(
          attributes[:url],
          port: attributes[:port],
          ssl: true
        )
      end

      it 'calls imap.login' do
        subject

        expect(imap).to have_received(:login).with(
          attributes[:user_name],
          attributes[:password]
        )
      end

      it 'returns instance of Mail::Imap::Queries::Select' do
        expect(subject).to be_instance_of(Mail::Imap::Queries::Select)
      end
    end

    context 'when fields are not provided' do
      context 'for url is not provided' do
        let(:attributes) { super().except(:url) }

        it 'raises KeyError error' do
          expect { subject }.to raise_error(KeyError, /option 'url'/)
        end
      end

      context 'for port is not provided' do
        let(:attributes) { super().except(:port) }

        it 'raises KeyError error' do
          expect { subject }.to raise_error(KeyError, /option 'port'/)
        end
      end

      context 'for user_name is not provided' do
        let(:attributes) { super().except(:user_name) }

        it 'raises KeyError error' do
          expect { subject }.to raise_error(KeyError, /option 'user_name'/)
        end
      end

      context 'for password is not provided' do
        let(:attributes) { super().except(:password) }

        it 'raises KeyError error' do
          expect { subject }.to raise_error(KeyError, /option 'password'/)
        end
      end
    end
  end
end
