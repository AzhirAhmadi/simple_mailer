# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to allow_value('test@emial.com').for(:email) }
    it { is_expected.not_to allow_value('test@emial').for(:email) }
    it { is_expected.not_to allow_value('testemial.com').for(:email) }
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
