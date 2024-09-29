require 'rails_helper'

RSpec.describe V1::User::Operation::Update, type: :operation   do
  context 'User Confirmation' do
    let!(:user) { create(:user, email:'testing@gmail.com')}
    let!(:admin_user) { create(:user, role: 'admin')}
    
    it 'is user updating successfully by authorised user' do
      result =
        described_class.(
          params:
            ActionController::Parameters.
              new({
              name: "Xyz",
              company_name: "ASD",
              id: user.id
            }),
          current_user: admin_user
        )
      expect(result.success?).to be_truthy
      expect(result[:user].name).to eq(user.reload.name)
    end

    it 'is user record not found' do
      result =
        described_class.(
          params:
            ActionController::Parameters.
              new({
              name: "Xyz",
              company_name: "ASD",
              id: User.last.id + 1
            }),
          current_user: admin_user
        )
      expect(result.failure?).to be_truthy
      expect(result[:error]).to eq(
        I18n.t('errors.not_found', model: 'user')
      )
    end
  end
end
