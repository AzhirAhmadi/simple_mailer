# frozen_string_literal: true

class MailKey < ApplicationRecord
  validates :subject, :message_id, presence: true

  belongs_to :user
end

# == Schema Information
#
# Table name: mail_keys
#
#  id         :bigint           not null, primary key
#  subject    :string           default("no subject"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  message_id :integer          not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_mail_keys_on_user_id                 (user_id)
#  index_mail_keys_on_user_id_and_message_id  (user_id,message_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
