module V1
  class TeamMemberSerializer <  CacheCrispies::Base
    serialize :id, :name, :email, :company_name, :designation, :status, :invited_at

  end
end
