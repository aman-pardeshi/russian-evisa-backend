# frozen_string_literal: true

class ReportsController < BaseController
  skip_before_action :authenticate!

  def submitted_applications
    run V1::Reports::Operation::SubmittedApplications do |result| 
      return cache_render V1::ReportsSerializer, result[:applications], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def applied_visa
    run V1::Reports::Operation::AppliedVisa do |result| 
      return cache_render V1::ReportsSerializer, result[:applications], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def processed_visa
    run V1::Reports::Operation::ProcessedVisa do |result| 
      return cache_render V1::ReportsSerializer, result[:applications], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def accounts_report
    run V1::Reports::Operation::AccountsReport do |result| 
      return cache_render V1::AccountsReportSerializer, result[:accounts], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end

  def incomplete_applications
    run V1::Reports::Operation::IncompleteApplications do |result| 
      return cache_render V1::IncompleteApplicationsReportSerializer, result[:applications], status: 200 
    end

    render json: { message: result[:error] }, status: ERROR_STATUS_CODE 
  end
end