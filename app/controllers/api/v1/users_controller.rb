# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      # GET api/v1/users
      def index
        render json: users, view: :index
      end

      # GET api/v1/users/1
      def show
        render json: user
      end

      # POST api/v1/users
      def create
        render json: User.create!(user_params)
      end

      # PATCH/PUT api/v1/users/1
      def update
        render json: user.tap { |user| user.update!(user_params) }
      end

      # DELETE api/v1/users/1
      def destroy
        render json: user.destroy!
      end

      private

      def users
        @_users ||= User.all
      end

      def user
        @_user ||= users.find(params[:id])
      end

      def user_params
        params.require(:data).permit(:email, :credential_data)
      end
    end
  end
end
