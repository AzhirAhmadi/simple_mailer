# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :id, :email, :created_at, :updated_at

  view :index do
    excludes :created_at, :updated_at
  end
end
