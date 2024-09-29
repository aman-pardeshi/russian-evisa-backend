require 'rails_helper'

RSpec.describe V1::User::Operation::SignInWithGoogle, type: :operation   do
  context 'SignIn/SignUp User using google' do
    
    it 'Can user signIn/SignUp using Google Login' do
      result =
        V1::User::Operation::SignInWithGoogle.
        (params: ActionController::Parameters.
          new({
            google_response: {
              accessToken: "ya29.a0AfH6SMBk_emPTvRvqVR2modDBulznrAgHdnn120qrI7gLpqPfEi_ZegxnYljeL5XtgCoXidxNC-wIE3qjRBEISieHXHrj1nEozpOHmgBH_ywfXi_5RembsIWrFaTbj-PeKzghCzJe3N1MYScG8Y-VbufkZP9m17xe6gl",
            profileObj: {
              googleId: "117331728813189843960",
              imageUrl: "https://lh3.googleusercontent.com/a-AOh14Gimkf_-Rw-0425QVtueNFbG1R1fx4oCW35u--YD=s96-c",
              email: "prashant.bangar@joshsoftware.com",
              name: "prashant bangar",
              givenName: "prashant",
              familyName: "bangar",
            }
          }
        }.as_json
      ))
      expect(result.success?).to be_truthy
      expect(result[:user].present?).to be_truthy
      expect(result[:user].google_account.present?).to be_truthy
    end

    it 'User Cant signIn/SignUp using Google Login with worng parameter' do
      result =
        V1::User::Operation::SignInWithGoogle.
        (params: ActionController::Parameters.
          new({
            google_response: {
              profileObj:{
              googleId: "117331728813189843960",
              imageUrl: "https://lh3.googleusercontent.com/a-AOh14Gimkf_-Rw-0425QVtueNFbG1R1fx4oCW35u--YD=s96-c"
            }
          }
        }.as_json
      ))
      expect(result.failure?).to be_truthy
      expect(result[:error].present?).to be_truthy
      expect(result[:error]).to eq(I18n.t('errors.params_missing',
        params:
         'google_response[:accessToken], google_response[:profileObj]'))
    end
  end
end
