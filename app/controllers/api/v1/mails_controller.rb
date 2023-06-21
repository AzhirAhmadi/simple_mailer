# frozen_string_literal: true

module Api
  module V1
    class MailsController < ApplicationController
      # GET /api/v1/users/:user_id/mails/:id
      def show
        result = Mail::Read.call(user: user, message_id: params[:id].to_i).value!

        render json: result
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
