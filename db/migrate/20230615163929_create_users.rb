# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.jsonb :credential_data, default: {}
      t.timestamps
    end
  end
end
