# frozen_string_literal: true

module V1
  class TrackStatusSerializer < CacheCrispies::Base
    serialize :id, :submission_id, :first_name, :last_name, :passport_number
    serialize :application_histories, with: V1::ApplicationHistorySerializer
  end
end