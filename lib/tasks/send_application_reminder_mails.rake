namespace "send_application_reminder_mails" do 
  desc "send reminder to incomplete applications" 
  task :send_reminder => :environment do 
    
    applications = Application.where(status: 'incomplete').order(:id)

    users = User.where(role: 'applicant')

    users.each do |user|
      incomplete_applications = user.applications.incomplete

      sorted_applications = incomplete_applications.sort_by do |application|
        Date.current.mjd - application.created_at.to_date.mjd
      end

      sorted_applications.each do |application|
        date_since_application = Date.current.mjd - application.created_at.to_date.mjd

        user = application.user

        puts "#{application.id} - #{date_since_application}"

        case date_since_application
          when 1
            UserMailer.first_application_reminder(user).deliver!
            break
          when 4
            UserMailer.second_application_reminder(user).deliver!
            break
          when 8
            UserMailer.third_application_reminder(user).deliver!
            break
          when 15
            UserMailer.forth_application_reminder(user).deliver!
            break
          when 31
            UserMailer.final_application_reminder(user).deliver!
            break
        end
      end
    end
  end
end