module V2
  class VisitorSerializer < CacheCrispies::Base
    serialize :company, :event, :last_visit

    def company
      if model.visitor_detail.company_detail.present? 
        model.visitor_detail.company_detail.as_json(only: [:id, :company_domain, :name, :category, :logo, :country_name], methods: [:country])
      else
        user = model.visitor_detail.user

        { id: user.id, name: user.company_name } if user.present?
      end
    end

    def event
      model.page.as_json(only: [:id, :title, :logo, :slug], methods: [:category])
    end

    def last_visit
      model.visitor_detail.visited_date
    end
  end
end