# frozen_string_literal: true

require 'mail'

module Mail
  class Read < LoginImap
    option :message_id, type: Types.Instance(Integer)

    def call
      raw_email = read_email_from_mail_box.first.attr['BODY[]']

      email = Mail.new(raw_email)
      Success(
        MailStruct.new(from: email.from.first,
                       to: email.to.first,
                       subject: email.subject,
                       body: email.body.to_s)
      )
    end

    private

    def read_email_from_mail_box
      imap.mailbox(name: 'INBOX')
        .search(query: 'ALL')
        .fetch(query: 'BODY.PEEK[]', custom_message_ids: [message_id])
    end
  end
end
