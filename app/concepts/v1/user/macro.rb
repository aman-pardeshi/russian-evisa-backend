# frozen_string_literal: true

module V1::User
  class Macro
    def self.LoadUser(find_by_key: :id)
      task = -> ((ctx, flow_options), _) do
        ctx[:user] = User.find_by(id: ctx[:params][find_by_key])
        if ctx[:user].present?
          return Trailblazer::Activity::Right, [ctx, flow_options]
        else
          return Trailblazer::Activity::Left, [ctx, flow_options]
        end
      end

      { task: task }
    end
  end
end
