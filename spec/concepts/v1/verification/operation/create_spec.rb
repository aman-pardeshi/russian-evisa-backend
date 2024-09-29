require 'rails_helper'

RSpec.describe V1::Verification::Operation::Create, type: :operation   do
  let!(:user) { create(:user, role: 'admin') }
  let!(:event) do
    create(:event, status: 'approved',
      created_by_id: user.id, 
      owner_id: user.id
    )
  end
  let!(:review) do
    create(:review,
      event_id: event.id,
      reviewer_id: user.id,
      reviewer_type: 'User',
    )
  end


  it 'is review verification create successfully' do
    result =
      described_class.
        call(
          current_user: user,
          review: review
        )
    expect(result.success?).to be_truthy
    expect(result[:verification].present?).to be_truthy
  end

  it 'is has_one verification for review' do
    review = Review.reflect_on_association(:verification)
    expect(review.macro).to eq(:has_one)
  end
end
