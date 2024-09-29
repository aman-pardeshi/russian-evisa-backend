require 'rails_helper'

RSpec.describe V1::User::Operation::ConfirmUser, type: :operation   do
  context 'User Confirmation' do
    let!(:user) { create(:user, email:'testing@gmail.com')}
    
    it 'is confirmation token valid and user confirmed email successfully' do
      result = V1::User::Operation::ConfirmUser.
        (params: { confirmation_token: user.confirmation_token })
      expect(result.success?).to be_truthy
      expect(result[:user].present?).to be_truthy 
    end
    
    it 'if confirmation token invalid' do
      result = V1::User::Operation::ConfirmUser.
        (params: { confirmation_token: "dfghjkl" })
      expect(result.failure?).to be_truthy
      expect(result[:error]).to eq(I18n.t('errors.messages.already_confirmed'))
    end
  end
end
