# frozen_string_literal: true

class MailKeySerializer < ApplicationSerializer
  identifier :id

  fields :id, :subject
end
