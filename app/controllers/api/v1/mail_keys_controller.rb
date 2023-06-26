# frozen_string_literal: true

module Api
  module V1
    class MailKeysController < ApplicationController
      # GET /api/v1/users/:user_id/mail_keys
      def index
        render json: mail_keys
      end

      # GET /api/v1/users/:user_id/mail_keys/sync
      def sync
        Mail::Imap::SyncMailKeys.call(user: user)

        render json: mail_keys, status: :ok
      end

      private

      def users
        @_users ||= User.all
      end

      def user
        @_user ||= users.find(params[:user_id])
      end

      def mail_keys
        MailKey.where(user_id: user.id)
      end
    end
  end
end
