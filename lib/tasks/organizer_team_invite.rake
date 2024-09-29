namespace "organizer_event_mapping" do
  desc "create_event_owner_invite"
  task :create_invite => :environment do
    Event.where(status: "approved").map do |event|
      EventMember.create(user_id: event.owner_id, event_id: event.id, invited_by: event.owner_id, status: "approved")
    end

    puts "EventMember created for existing event owner ids"
  end
end
