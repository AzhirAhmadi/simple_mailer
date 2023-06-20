# frozen_string_literal: true

module Mail
  class FetchInboxSubjects < ApplicationService
    option :user, type: Types.Instance(User)

    def call
      result = imap.mailbox(name: 'INBOX')
        .search(query: 'ALL')
        .fetch(query: 'BODY[HEADER.FIELDS (SUBJECT)]')

      filtered_result = result.flat_map { |i| i.attr.values }
        .map { |i| i.gsub('Subject:', '').strip.presence || 'no subject' }

      Success(filtered_result)
    end

    private

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
