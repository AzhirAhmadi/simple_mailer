# frozen_string_literal: true

module Mail
  class LoginImap < ApplicationService
    option :user, type: Types.Instance(User)
    option :credential_key, type: Types::String

    protected

    def imap
      @_imap ||= Mail::ImapConnection.connect(**ceredentials)
    end

    def ceredentials
      {
        url: credentials[:url],
        port: credentials[:port],
        user_name: credentials[:user_name],
        password: credentials[:password]
      }
    end

    def credentials
      user.credential_hash[credential_key.to_sym]
    end
  end
end
