# frozen_string_literal: true

# read more here https://datatracker.ietf.org/doc/html/rfc3501#section-6.4.4
module Mail
  module Imap
    module Queries
      class Search < Base
        option :imap, type: Types::Instance(Net::IMAP)

        def search(query:)
          message_ids = imap.search(query)

          Mail::Imap::Queries::Fetch.new(imap: imap, message_ids: message_ids)
        end
      end
    end
  end
end
