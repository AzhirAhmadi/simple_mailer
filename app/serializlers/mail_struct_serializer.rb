# frozen_string_literal: true

class MailStructSerializer < ApplicationSerializer
  fields :from, :to, :subject, :body
end
