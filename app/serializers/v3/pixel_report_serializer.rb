module V3
  class PixelReportSerializer < CacheCrispies::Base
    serialize :id, :user, :event, :event_category, :mail_trigger, :user_status, :mail_opened, :link_clicked, :unsubscribe_status

    def user
      model&.user.as_json(only: [:id, :name, :email, :designation, :company_name])
    end

    def event
      model&.event.as_json(only: [:id, :title, :edition])
    end

    def event_category
      model&.event.category
    end
  end
end