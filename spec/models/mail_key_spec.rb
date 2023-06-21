# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailKey, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:mail_key) }

    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:message_id) }

    context 'when validating user_id and message_id uniqueness' do
      let(:user) { create(:user) }
      let(:message_id) { 1 }
      let(:new_message_id) { 2 }
      let(:new_user) { create(:user) }

      before do
        create(:mail_key, user_id: user.id, message_id: message_id)
      end

      it 'does not create mail_key with same user_id and message_id' do
        expect {
          described_class.create!(user_id: user.id, message_id: message_id)
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end

      it 'creates mail_key with same user_id' do
        expect {
          described_class.create!(user_id: user.id, message_id: new_message_id)
        }.to change(described_class, :count).from(1).to(2)
      end

      it 'creates mail_key with same message_id' do
        expect {
          described_class.create!(user_id: new_user.id, message_id: message_id)
        }.to change(described_class, :count).from(1).to(2)
      end

      it 'creates mail_key with deferent user_id and message_id' do
        expect {
          described_class.create!(user_id: new_user.id, message_id: new_message_id)
        }.to change(described_class, :count).from(1).to(2)
      end
    end
  end
end

# == Schema Information
#
# Table name: mail_keys
#
#  id         :bigint           not null, primary key
#  subject    :string           default("no subject"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  message_id :string           not null
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
