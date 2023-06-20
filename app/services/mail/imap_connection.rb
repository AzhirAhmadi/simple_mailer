# frozen_string_literal: true

require 'net/imap'

module Mail
  class ImapConnection < ApplicationService
    option :url, type: Types::String
    option :port, type: Types::Integer
    option :user_name, type: Types::String
    option :password, type: Types::String

    class << self
      alias connect call
    end

    def call
      imap = Net::IMAP.new(url, port: port, ssl: true)
      imap.login(user_name, password)

      Queries::Select.new(imap: imap)
    end
  end
end
