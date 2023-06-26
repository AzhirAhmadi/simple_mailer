# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@dataguard.de" }
    credential_data {
      {
        imap: { key1: 'value1', key2: 'value2' },
        smtp: { key1: 'value1', key2: 'value2' }
      }.to_json
    }
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
