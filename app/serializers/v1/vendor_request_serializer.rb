module V1
  class VendorRequestSerializer < CacheCrispies::Base

    serialize :id, :name, :designation, :company_name, :email, :linkedin_url,
      :twitter_handle, :status, :is_event_listed, :approved_by,
      :approved_at, :rejected_at, :created_at, :role, :signup_source

    def approved_by
      model.approved_by&.as_json(only: [:name, :role])
    end

    def created_at
      V1::DateTimeFormatter.format_date_time(model&.created_at)
    end
  end
end
