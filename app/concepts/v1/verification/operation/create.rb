module V1::Verification::Operation
  class Create < Trailblazer::Operation

    pass :initialize_object
    pass :check_outreach_database
    pass :check_campaign_amount
    step :save
    fail V1::Api::Macro.SomethingWentWrong

    def initialize_object(ctx, review:, **)
      ctx[:verification] = Verification.new(review: review)
    end

    def check_outreach_database(ctx, review:, verification:, **)
      event = review.event
      reviewer = review.reviewer
      reviewer_first_name = reviewer.first_name.downcase
      reviewer_last_name = reviewer.last_name&.downcase
      reviewer_email = reviewer.email.downcase
      contact = event.outreach_contacts.where(email: reviewer_email).
        or(
          event.outreach_contacts.where(
            first_name: reviewer_first_name,
            last_name: reviewer_last_name
          )
        )
      ctx[:verification].exists_on_outreach_db = contact.present?
    end

    def check_campaign_amount(ctx, verification:, review:, **)
      ctx[:verification].gc_amount = review&.campaign_link&.reward_amount
      ctx[:verification].gc_amount_approved = review&.campaign_link.present?
    end

    def save(ctx, verification:, **)
      verification.save
    end
  end
end