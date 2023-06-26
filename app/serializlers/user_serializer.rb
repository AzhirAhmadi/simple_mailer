# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :id, :email, :created_at, :updated_at

  field :credential_keys do |user|
    user.credential_hash.keys
  end

  view :index do
    excludes :created_at, :updated_at, :credential_keys
  end
end
