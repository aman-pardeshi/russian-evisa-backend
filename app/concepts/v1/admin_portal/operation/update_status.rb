# frozen_string_literal: true

module V1::AdminPortal::Operation
  class UpdateStatus < Trailblazer::Operation
    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

  end
end