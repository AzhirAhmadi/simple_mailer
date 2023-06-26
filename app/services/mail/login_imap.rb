# frozen_string_literal: true

module Mail
  class LoginImap < ApplicationService
    option :user, type: Types.Instance(User)

    protected

    def imap
      @_imap ||= Mail::ImapConnection.connect(**ceredentials)
    end

    def ceredentials
      {
        url: user.credential_hash[:imap][:url],
        port: user.credential_hash[:imap][:port],
        user_name: user.credential_hash[:imap][:user_name],
        password: user.credential_hash[:imap][:password]
      }
    end
  end
end
