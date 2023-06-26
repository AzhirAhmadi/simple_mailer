# frozen_string_literal: true

require 'net/smtp'

module Mail
  class SmtpSender < ApplicationService
    option :credentials, type: Types.Instance(Hash)
    option :to, type: Types::String
    option :cc, type: Types::Array.of(Types::String), default: proc { [] }
    option :bcc, type: Types::Array.of(Types::String), default: proc { [] }
    option :subject, type: Types::String, default: proc { '' }
    option :body, type: Types::String

    def call
      smtp = Net::SMTP.new(credentials[:url], credentials[:port])

      smtp.start(*start_params)
      smtp.send_message(*send_message_params)
      smtp.finish
    end

    private

    def start_params
      [
        credentials[:domain],
        credentials[:user_name],
        credentials[:password],
        :login
      ]
    end

    def send_message_params
      message = <<~EMAIL
        Subject: #{subject}
        To: #{to}
        CC: #{cc.join(',')}
        BCC: #{bcc.join(',')}

        #{body}
      EMAIL

      [
        message,
        credentials[:user_name],
        to,
        (cc + bcc)
      ]
    end
  end
end
