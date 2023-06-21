# frozen_string_literal: true

module Mail
  class FetchInboxSubjects < LoginImap
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
  end
end
