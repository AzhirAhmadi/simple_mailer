# frozen_string_literal: true

module Net
  class SMTP
    class ResponseSerializer < ApplicationSerializer
      fields :status, :string
    end
  end
end
