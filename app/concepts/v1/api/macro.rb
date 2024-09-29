module V1::Api
  class Macro

    def self.CheckAuthorizedUser
      task = -> ((ctx, flow_options), _) do
        if ctx[:current_user].role.present? ||
          (ctx[:params][:id].present? && ctx[:params][:id].to_i == ctx[:current_user].id)
          return Trailblazer::Activity::Right, [ctx, flow_options]
        else
          return Trailblazer::Activity::Left, [ctx, flow_options]
        end
      end

      { task: task }
    end

    def self.AccessDenied(fail_fast: true)
      task = -> ((ctx, flow_options), _) do
        ctx[:error] = I18n.t('errors.unauthorized_user')
        return Trailblazer::Activity::Left, [ctx, flow_options]
      end

      { task: task, fail_fast: fail_fast }
    end

    def self.SomethingWentWrong(fail_fast: true)
      task = -> ((ctx, flow_options), _) do
        ctx[:error] = I18n.t('errors.something_went_wrong')
        return Trailblazer::Activity::Left, [ctx, flow_options]
      end

      { task: task, fail_fast: fail_fast }
    end

    def self.ParamsMissing(params:, fail_fast: true)
      task = -> ((ctx, flow_options), _) do
        ctx[:error] =  I18n.t('errors.params_missing', params: params)
        return Trailblazer::Activity::Left, [ctx, flow_options]
      end

      { task: task, fail_fast: fail_fast }
    end

    def self.InvalidParamValue(param:, value:, fail_fast: true)
      task = -> ((ctx, flow_options), _) do
        ctx[:error] = I18n.t('errors.invalid_param_value', param: param, value: value)
        return Trailblazer::Activity::Left, [ctx, flow_options]
      end

      { task: task, fail_fast: fail_fast }
    end

    def self.RecordNotFound(model_name,fail_fast: true)
      task = -> ((ctx, flow_options), _) do
        ctx[:error] = I18n.t('errors.not_found', model: model_name )
        return Trailblazer::Activity::Left, [ctx, flow_options]
      end

      { task: task, fail_fast: fail_fast }
    end
  end
end
