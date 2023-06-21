# frozen_string_literal: true

class ChangeMessageIdTypeToInteger < ActiveRecord::Migration[7.0]
  def up
    change_column(:mail_keys, :message_id, :integer, using: 'message_id::integer')
  end

  def down
    change_column(:mail_keys, :message_id, :string)
  end
end
