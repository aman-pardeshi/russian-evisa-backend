# if environment == 'production'
#   # Every day at 12:30 am
#   every 1.day, at: '7.00 pm' do
#     rake 'utils:db_backup'
#   end
# end

every 6.month do
  rake "audited_cleaner:perform"
end

#At 12:00 AM, every 15 days
# every '0 0 */15 * *' do
#   rake "generate_sitemap_xml:create_xml_of_published_urls"
# end

# At 12:00 AM, every day
every '0 0 * * *' do
  rake "send_application_reminder_mails:send_reminder"
end

# #At 12:00 AM, every day
# every '0 0 * * *' do
#   rake "pre_event_triggers:send_organizer_trigger"
#   rake "send_remaining_trigger_for_speaker_call:send_triggers"
# end

