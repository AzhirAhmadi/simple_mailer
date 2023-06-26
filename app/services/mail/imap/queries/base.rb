# frozen_string_literal: true

module Mail
  module Imap
    module Queries
      class Base
        extend Dry::Initializer
        include Dry::Monads[:result, :do]
      end
    end
  end
end
