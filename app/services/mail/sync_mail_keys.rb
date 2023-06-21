# frozen_string_literal: true

module Mail
  class SyncMailKeys < ApplicationService
    option :user, type: Types.Instance(User)

    def call
      upsert_mail_keys
      delete_old_mail_keys
    end

    private

    def upsert_mail_keys
      return if incoming_attributes.empty?

      MailKey.upsert_all(incoming_attributes, unique_by: :index_mail_keys_on_user_id_and_message_id)
    end

    def delete_old_mail_keys
      MailKey.where(user_id: user.id).where.not(message_id: incoming_message_ids).delete_all
    end

    def incoming_message_ids
      @_incoming_message_ids ||= incoming_attributes.pluck(:message_id)
    end

    def incoming_attributes
      @_incoming_attributes ||= fetch_inbox_subjects_result.value!.map do |attribute|
        attribute.merge({ user_id: user.id })
      end
    end

    def fetch_inbox_subjects_result
      @_fetch_inbox_subjects_result ||= FetchInboxSubjects.call(user: user)
    end
  end
end
