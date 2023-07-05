# frozen_string_literal: true

module Api
  module V1
    class MailsController < ApplicationController
      # GET /api/v1/users/:user_id/mails/:id
      def show
        result = Mail::Imap::Read.call(user: user, message_id: params[:id].to_i).value!

        render json: result
      end

      def create
        arributes = create_params.to_h
          .merge(credentials: user.credential_hash[:smtp])
          .deep_symbolize_keys

        result = Mail::SmtpSender.call(**arributes)

        render json: result.value!
      end

      private

      def users
        @_users ||= User.all
      end

      def user
        @_user ||= users.find(params[:user_id])
      end

      def create_params
        params.require(:data).permit(:to, :subject, :body, cc: [], bcc: [])
      end
    end
  end
end
