class V1::DateTimeFormatter
  def self.format_date date
    date.strftime("#{date.day.ordinalize} %b %Y")
  end

  def self.format_date_time date_time
    "#{date_time&.strftime("#{date_time&.day.ordinalize} %b %Y")} #{date_time&.in_time_zone('Asia/Kolkata')&.strftime("%I:%M %p")}"
  end 
end