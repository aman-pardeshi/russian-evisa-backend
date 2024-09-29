require 'rails_helper'

RSpec.describe V1::User::Operation::ValidateEmail, type: :operation   do
  context 'Verify Email Present in system or not' do
    let!(:user) { create(:user) }

    it 'is email address is uniq' do
      result = described_class.call(params: ActionController::Parameters.new({email: "xyz@gmail.com"}))
      expect(result.success?).to be_truthy
    end
    
    it 'is email address present in system' do
      result = described_class.call(params: ActionController::Parameters.new({email: user.email}))
      expect(result.failure?).to be_truthy
    end
  end
end
