# frozen_string_literal: true

class User < ApplicationRecord
  EMAIL_REGEX = /\b[A-Z0-9.!_%$\#&*\^+-]+@[A-Z0-9.\-_]+\.[A-Z]+\b/i

  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :credential_data, json_format: true

  def credential_hash
    Oj.load(credential_data, symbol_keys: true)
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  credential_data :jsonb
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
