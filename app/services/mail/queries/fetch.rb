# frozen_string_literal: true

# read more here https://datatracker.ietf.org/doc/html/rfc3501#section-6.4.5
module Mail
  module Queries
    class Fetch < Base
      option :imap, type: Types::Instance(Net::IMAP)
      option :message_ids, type: Types::Instance(Array)

      def fetch(query:)
        imap.fetch(message_ids, query)
      end
    end
  end
end
