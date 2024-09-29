module V1::Dashboard::Operation
  class CalculateFlagedReasonsPercentage < Trailblazer::Operation
    
    step :calculate_flag_reasons

    def calculate_flag_reasons(ctx, reviews:, **)
      flaged_reviews = reviews.where(is_flaged: true)
      did_not_attended_event  = flaged_reviews.where(flaged_reason: I18n.t('flag_reasons.did_not_attend_event')).count
      content_in_appropriate_language = flaged_reviews.where(flaged_reason: I18n.t('flag_reasons.in_appropriate_lang')).count
      is_duplicate = flaged_reviews.where(flaged_reason: I18n.t("flag_reasons.is_duplicate")).count
      predefined_reasons = I18n.t('flag_reasons').values
      other = flaged_reviews.where.not(flaged_reason: predefined_reasons).count
      flaged_reviews_count = flaged_reviews.count
      records =
        {
          did_not_attended_event:
            calculate_percentage(did_not_attended_event, flaged_reviews_count),
          content_in_appropriate_language:
            calculate_percentage(content_in_appropriate_language, flaged_reviews_count),
          is_duplicate: calculate_percentage(is_duplicate, flaged_reviews_count),
          other: calculate_percentage(other, flaged_reviews_count),
        }
      ctx[:records] = 
        records.each do |key, value|
          records[key] = 
          ActiveSupport::NumberHelper.number_to_delimited(value)
        end
    end

    private

    def calculate_percentage(reason_count, total)
      begin
        (reason_count == 0 || total == 0) ? 0 : ((reason_count.to_f/total.to_f) * 100).to_i
      rescue
        0.0
      end
    end
  end
end
