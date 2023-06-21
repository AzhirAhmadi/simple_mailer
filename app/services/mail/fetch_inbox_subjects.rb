# frozen_string_literal: true

module Mail
  class FetchInboxSubjects < ApplicationService
    option :user, type: Types.Instance(User)

    def call
      filtered_result = mail_data.map do |i|
        { message_id: i.seqno, subject: i.attr.values.last }
      end

      filtered_result.each do |i|
        subject = i[:subject].gsub('Subject:', '').strip
        i[:subject] = subject.presence || 'no subject'
      end

      Success(filtered_result)
    end

    private

    def mail_data
      imap.mailbox(name: 'INBOX')
        .search(query: 'ALL')
        .fetch(query: 'BODY.PEEK[HEADER.FIELDS (SUBJECT)]')
    end

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
