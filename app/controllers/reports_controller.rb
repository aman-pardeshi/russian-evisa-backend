# frozen_string_literal: true

class ReportsController < BaseController
  skip_before_action :authenticate!

  def submitted_applications
  end

  def applied_visa
  end

  def processed_visa
  end

  def accounts_report
  end

  def incomplete_applications
  end
end