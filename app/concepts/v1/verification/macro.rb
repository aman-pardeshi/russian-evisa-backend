module V1::Verification
  class Macro

    def self.LoadVerification(find_by_key: :id)
      task = -> ((ctx, flow_options), _) do
        ctx[:verification] = Verification.find_by(id: ctx[:params][find_by_key])
        if ctx[:verification].present?
          return Trailblazer::Activity::Right, [ctx, flow_options]
        else
          return Trailblazer::Activity::Left, [ctx, flow_options]
        end
      end

      { task: task }
    end

    def self.SanitizeParams
      task = -> ((ctx, flow_options), _) do
        ctx[:sanitized_params] = 
        ctx[:params].
        permit(
          :exists_on_outreach_db, :valid_linkedin_profile,
          :not_competitor_or_representative,
          :not_violent_lang, :not_duplicate_review, :gc_amount_approved,
          :gc_amount, :add_on_incentive, :incentive_value,
          :on_hold, :on_hold_reason
        )
        return Trailblazer::Activity::Right, [ctx, flow_options]
      end
    end
    
  end
end