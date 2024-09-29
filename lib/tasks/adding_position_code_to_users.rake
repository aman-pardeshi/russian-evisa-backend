namespace "adding_position_code_to_users" do
  desc "add_position_code"
  task :add_position_code => :environment do

    users = User.all.order(:id)

    ceo_position_db = Position.where(name: 'CEO').first
    marketing_position_db = Position.where(name: 'Marketing').first
    event_position_db = Position.where(name: 'Event').first
    demand_gen_position_db = Position.where(name: 'Demand Generation').first
    digital_position_db = Position.where(name: 'Digital').first
    content_position_db = Position.where(name: 'Content').first
    social_media_position_db = Position.where(name: 'Social Media').first

    users.map do |user|
      puts user.id
      position = user.designation.present? ? user.designation.downcase : nil

      if position.present?
        is_social_media_position = position.include?('social media')
        if is_social_media_position
          user.update(position_id: social_media_position_db.id)
        end

        is_content_position = position.include?('content')
        if is_content_position
          user.update(position_id: content_position_db.id)
        end

        is_digital_position = position.include?('digital')
        if is_digital_position
          user.update(position_id: digital_position_db.id)
        end

        is_demand_gen_position = position.include?('demand') &&
           (position.include?('generation') || position.include?('gen'))
        if is_demand_gen_position
          user.update(position_id: demand_gen_position_db.id)
        end

        is_event_position = position.include?('event')
        if is_event_position
          user.update(position_id: event_position_db.id)
        end

        is_marketing_position = position.downcase.include?('chief marketing officer') || 
        position.downcase.include?('cmo') || 
        position.include?('marketing')
        if is_marketing_position
          user.update(position_id: marketing_position_db.id)
        end

        is_ceo_position = position.include?('ceo') || position.include?('chief executive officer') || position.include?('founder')
        if is_ceo_position
         user.update(position_id: ceo_position_db.id)
        end
      end
    end
  end
end
