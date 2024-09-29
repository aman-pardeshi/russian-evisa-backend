namespace :audited_cleaner do
  desc "Delete old audited records"
  task :perform => :environment do
    month = Integer(ENV["DELETE_AUDITED_BEFORE_MONTH"]) rescue 6
    date = Date.today.beginning_of_month - month.month
    Audited::Audit.where("created_at < ?", date.beginning_of_day).delete_all
    puts "Cleaned Audited data before #{month} months"
  end
end