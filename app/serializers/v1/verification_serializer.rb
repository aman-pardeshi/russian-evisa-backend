module V1
  class VerificationSerializer < CacheCrispies::Base
    serialize :id, :exists_on_outreach_db, :valid_linkedin_profile,
      :not_competitor_or_representative,
      :not_violent_lang, :not_duplicate_review, :gc_amount_approved,
      :gc_amount, :add_on_incentive, :incentive_value,
      :on_hold, :on_hold_reason
      :review_id
  end
end
