# frozen_string_literal: true

class CreateMailKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :mail_keys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message_id, null: false
      t.string :subject, null: false, default: 'no subject'

      t.timestamps
    end

    add_index :mail_keys, %i(user_id message_id), unique: true
  end
end
