module V1::Params
  def self.create(param_hash)
    ActionController::Parameters.new(param_hash )
  end
end