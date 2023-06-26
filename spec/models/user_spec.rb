# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to allow_value('test@emial.com').for(:email) }
    it { is_expected.not_to allow_value('test@emial').for(:email) }
    it { is_expected.not_to allow_value('testemial.com').for(:email) }

    it { is_expected.to allow_value({ key1: 'value' }.to_json).for(:credential_data) }
    it { is_expected.not_to allow_value('invalid').for(:credential_data) }
    it { is_expected.to allow_value({}.to_json).for(:credential_data) }
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
