module V1::Verification::Operation
  class Update < Trailblazer::Operation

    step V1::Api::Macro.CheckAuthorizedUser
    fail V1::Api::Macro.AccessDenied

    step :check_params
    fail V1::Api::Macro.ParamsMissing(params: 'review_id, id')

    # step V1::Review::Macro.LoadReview(find_by_key: :review_id)
    # fail V1::Api::Macro.RecordNotFound('review')

    step V1::Verification::Macro.LoadVerification
    fail V1::Api::Macro.RecordNotFound('verification')

    step V1::Verification::Macro.SanitizeParams
    step :update
    fail :update_fail, fail_fast: true

    pass :check_hold_status_and_update_review_status
    fail V1::Api::Macro.SomethingWentWrong

    def check_params(ctx, params:, **)
      params[:review_id].present? &&
      params[:id].present?
    end

    def update(ctx, verification:, sanitized_params:, current_user:, **)
      verification.update!(sanitized_params.merge(updated_by: current_user))
    end

    def update_fail(ctx, verification:, **)
      ctx[:error] = verification.errors.full_messages
    end

    def check_hold_status_and_update_review_status(ctx, verification:, review:, **)
      if verification.on_hold
        review.on_hold!
      end
    end
  end
end