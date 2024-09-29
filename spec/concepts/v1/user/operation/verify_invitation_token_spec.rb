require 'rails_helper'

RSpec.describe V1::User::Operation::VerifyInvitationToken, type: :operation   do
  context 'Verify Invitation Token' do
    let!(:user) { create(:user) }
    let(:invitation_token_string) do
      raw, enc = Devise.token_generator.generate(User, :invitation_token)
      user.update(invitation_token: enc)
      raw
    end

    it 'is invitation token validate successfully' do
      user.invite!(user)
      result = described_class.call(params: ActionController::Parameters.new({invitation_token: invitation_token_string}))
      expect(result.success?).to be_truthy
    end
    
    it 'is invalid invitation token' do
      result = described_class.call(params: ActionController::Parameters.new({invitation_token: "sdfghjk"}))
      expect(result.failure?).to be_truthy
    end
  end
end
