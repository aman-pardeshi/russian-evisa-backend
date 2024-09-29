FactoryBot.define do
  factory :verification, class: Verification do
    exists_on_outreach_db { true }
    valid_linkedin_profile { true }
    not_competitor_or_representative { true }
    not_violent_lang { false }
    not_duplicate_review { false }
    gc_amount_approved { true }
    gc_amount { '10' }
    add_on_incentive { true}
    incentive_value { '50' }
    on_hold { true }
    on_hold_reason { "On Hold" }
    association :created_by, factory: :user
  end
end
