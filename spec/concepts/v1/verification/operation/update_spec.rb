require 'rails_helper'

RSpec.describe V1::Verification::Operation::Update, type: :operation   do
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
  let!(:verification_params) do
    {
    exists_on_outreach_db: 'false',
    valid_linkedin_profile: 'true',
    not_competitor_or_representative: 'false',
    not_violent_lang: 'true',
    not_duplicate_review: 'true',
    gc_amount_approved: 'false',
    gc_amount: '10',
    add_on_incentive: 'true',
    incentive_value: '50',
    on_hold: 'true',
    on_hold_reason: 'false'
    }
  end
  let!(:verification) { create(:verification, review_id: review.id) }

  it 'is review verification failed for unauthorized user' do
    user.update(role: nil)
    verification_params[:review_id] = review.id
    verification_params[:id] = verification.id
    result =
      described_class.
      call(
        current_user: user,
        params: ActionController::Parameters.new(verification_params)
      )
    expect(result.failure?).to be_truthy
    expect(result[:error]).to eq(I18n.t('errors.unauthorized_user'))
  end

  it 'should review status changed to on_hold if review verification set on_hold to true' do
    verification_params[:review_id] = review.id
    verification_params[:id] = verification.id
    result =
      described_class.
      call(
        current_user: user,
        params: ActionController::Parameters.new(verification_params)
      )
    review.reload
    expect(result.success?).to be_truthy
    expect(review.status).to eq('on_hold')
  end

  it 'should not update review status if on_hold false' do
    verification_params[:review_id] = review.id
    verification_params[:id] = verification.id
    verification_params[:on_hold] = false
    result =
      described_class.
      call(
        current_user: user,
        params: ActionController::Parameters.new(verification_params)
      )
    review.reload
    expect(result.success?).to be_truthy
    expect(review.status).not_to eq('on_hold')
  end

  it 'should update verification updated_by value with current_user' do
    verification_params[:review_id] = review.id
    verification_params[:id] = verification.id
    result =
      described_class.
      call(
        current_user: user,
        params: ActionController::Parameters.new(verification_params)
      )
    verification.reload
    expect(result.success?).to be_truthy
    expect(verification.updated_by_id).to eq(user.id)
  end

  it 'if invalid review id send' do
    verification_params[:review_id] = Review.last.id + 1
    verification_params[:id] = verification.id
    result =
      described_class.
      call(
        current_user: user,
        params: ActionController::Parameters.new(verification_params)
      )
    expect(result.failure?).to be_truthy
    expect(result[:error]).to eq(I18n.t('errors.not_found',model: 'review'))
  end

  it 'should return param missing error if review id is not present' do
    result =
      described_class.
      call(
        current_user: user,
        params: ActionController::Parameters.new(verification_params)
      )
    expect(result.failure?).to be_truthy
    expect(result[:error]).to eq(I18n.t('errors.params_missing',params: 'review_id, id'))
  end

  it 'is review verification update successfully' do
    verification_params[:review_id] = review.id
    verification_params[:id] = verification.id
    result =
      described_class.
        call(
          current_user: user,
          params: ActionController::Parameters.new(verification_params)
        )
    expect(result.success?).to be_truthy
    expect(result[:verification].present?).to be_truthy
  end
end
