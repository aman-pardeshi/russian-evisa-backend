require 'rails_helper'

RSpec.describe V1::User::Operation::ForgotPassword, type: :operation   do
  context 'Forget Password' do
    let!(:user) { create(:user) }

    it 'is email is valid then reset password link sent successfully' do
      result =
        described_class.
        call(params: ActionController::Parameters.new({email: user.email}))
      expect(result.success?).to be_truthy
    end
    
    it 'is email invalid then sent error' do
      result =
        described_class.call(params: ActionController::Parameters.new({email: "sdfghjk"}))
      expect(result.failure?).to be_truthy
    end
  end
end
