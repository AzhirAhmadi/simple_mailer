# frozen_string_literal: true

# read more here https://datatracker.ietf.org/doc/html/rfc3501#section-6.3.1
module Mail
  module Imap
    module Queries
      class Select < Base
        option :imap, type: Types::Instance(Net::IMAP)

        def mailbox(name:)
          imap.select(name)

          Mail::Imap::Queries::Search.new(imap: imap)
        end
      end
    end
  end
end
