require 'rails_helper'

RSpec.describe V1::User::Operation::Delete, type: :operation   do
  context 'Get User Details' do
    let!(:user) { create(:user, email:'testing@gmail.com')}
    let!(:admin_user) { create(:user, role: 'admin')}

    it 'is user deleting correctly' do
      result =
        described_class.(
          params:
            ActionController::Parameters.
              new({
              id: user.id
            }),
          current_user: admin_user
        )
      expect(result.success?).to be_truthy
    end

    it 'if user not found' do
      result =
        described_class.(
          params:
            ActionController::Parameters.
              new({
              id: User.last.id + 1
            }),
          current_user: admin_user
        )
      expect(result.failure?).to be_truthy
      expect(result[:error]).to eq(
        I18n.t('errors.not_found', model: 'user')
      )
    end

    it 'is user deletion failed to unauthorised user' do
      admin_user.update(role: nil)
      result =
        described_class.(
          params:
            ActionController::Parameters.
              new({
              id: user.id
            }),
          current_user: admin_user
        )
      expect(result.failure?).to be_truthy
      expect(result[:error]).to eq(
        I18n.t('errors.unauthorized_user')
      )
    end
  end
end
