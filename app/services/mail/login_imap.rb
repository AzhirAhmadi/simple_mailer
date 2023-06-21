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
        url: user.credential_data['url'],
        port: user.credential_data['port'],
        user_name: user.credential_data['user_name'],
        password: user.credential_data['password']
      }
    end
  end
end
