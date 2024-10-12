# frozen_string_literal: true

module V1
  class ApplicationHistorySerializer < CacheCrispies::Base
    serialize :id, :application_id, :user, :description, :created_at, :date, :time

    def date
      model.created_at.strftime("%B %d, %Y")
    end

    def time
      model.created_at.strftime("%I:%M %p")
    end
  end
end