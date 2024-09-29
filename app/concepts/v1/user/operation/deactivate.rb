module V1::User::Operation
  class Deactivate < Trailblazer::Operation

    step :deactivate
    fail V1::Api::Macro.SomethingWentWrong

    def deactivate(ctx, current_user:, **)
      current_user.inactive!
    end
  end
end