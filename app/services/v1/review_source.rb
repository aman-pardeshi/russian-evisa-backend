class V1::ReviewSource

  def initialize(review)
    @review = review
  end

  def get_source_text
    return ["Organic",nil] if @review.web?
    campaign_source_text
  end

  def campaign_source_text
    heading_text = 
      if @review.campaign_link.created_for.eql?('admin')
        "Invitation from Eventible"
      elsif @review.campaign_link.created_for.eql?('organizer')
        "Invitation from Organizer"
      end
      description_text=
      if @review.campaign_link.has_amount?
        "The reviewer was offered a nominal gift card as"\
        " a token of appreciation for completing the review "
      else
        nil 
      end
    return [heading_text, description_text]
  end
end