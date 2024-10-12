# frozen_string_literal: true

module V1::EvisaApplication::Operation
  class Create < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :create
    
    def create(ctx, current_user:, **)
      ctx[:reference_id] = Application.create({user: ctx[:current_user]}).reference_id
    end
  end
end