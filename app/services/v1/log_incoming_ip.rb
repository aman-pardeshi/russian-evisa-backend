class V1::LogIncomingIp
  def initialize(ip_address, user, request)
    @client_ip = ip_address
    @user = user
    @request = request
    @email_regex = /\A[^@\s]+@(eventible\.com|eventible\.in)\z/i
  end

  def log_ip
    blacklisted_ips = [
      "103.51.135.93", 
      "103.163.190.76", 
      "115.160.223.150", 
      "125.20.55.178", 
      "125.20.75.138",
      "125.20.75.140", 
      "192.168.1.104"
    ]

    return if blacklisted_ips.include?(@client_ip)
    
    user_agent = @request.user_agent
    event_slug = @request.params[:slug]
    event = Event.where(slug: event_slug).order(:end_date).last

    return if event.nil?
    return if @email_regex.match?(@user.email)

    if @user.present? 
      existing_visitor_detail = VisitorDetail.where(
        source: "Organic",
        user_id: @user.id,
        visited_date: Date.today.to_s
      ).order(:created_at).last

      checking_for_ip = IpAddress.where(
        ip: @client_ip,
        visitor_type: @user.class.to_s,
        visitor_id: @user.id
      )

      unless checking_for_ip.present? 
        ip_entry = IpAddress.new(
          ip: @client_ip,
          visitor_type: @user.class.to_s,
          visitor_id: @user.id
        )

        ip_entry.save! if ip_entry.valid?
      end

      if existing_visitor_detail.present? 
        visitor_detail = existing_visitor_detail
      else
        visitor_detail_params = {
          source: "Organic",
          user_id: @user.id,
          visited_date: Date.today.to_s,
          device: isMobile(user_agent) ? "Mobile" : "Desktop"
        }

        visitor_detail = VisitorDetail.new(visitor_detail_params)
        visitor_detail.save! if visitor_detail.valid?
      end
      
      existing_page = VisitedPage.where(
        visitor_detail_id: visitor_detail.id,
        category: "event",
        page_id: event.id,
      ).order(:created_at).last

      if existing_page.present?
        visited_page = existing_page 
        visited_page.increment!(:visit)
      else
        visited_page = VisitedPage.new(
          visitor_detail: visitor_detail,
          category: "event",
          page_id: event.id,
          visit: 1
        )

        visited_page.save! if visited_page.valid?
      end

    else
      isIpExist = ClientIp.where("DATE(created_at) = ? AND ip = ? AND page = ?", 
      Date.today, @client_ip, "/#{event.category}/#{event_slug}").first

      if isIpExist.present?
        isIpExist.increment!(:visits) 
      else
        entry = ClientIp.new(
          ip: @client_ip, 
          user_agent: user_agent, 
          visits: 1, 
          page: "/#{event.category}/#{event_slug}", 
          device: isMobile(user_agent) ? 'Mobile' : 'Desktop')
        entry.save!
      end
    end
  end

  def isMobile(user_agent)
    regex = /Mobi|Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i

    regex.match?(user_agent)
  end
end