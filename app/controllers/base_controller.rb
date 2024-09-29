class BaseController < ApplicationController
  before_action :authenticate!, :log_user_actions

  def authenticate!
    current_user || render_unauthorized
  end

  def current_user
    return false unless request.headers["Authorization"].present?

    claims = ApiKeyHandler.decode_api_key(request.headers["Authorization"])
    @current_user = User.find(claims[0]['user_id'])
    rescue JWT::ExpiredSignature
      render_expired_message
    rescue JWT::DecodeError
      render_decode_error
  end

  def render_expired_message
    render_message(message: I18n.t('errors.expired_token'), status: 401)
  end

  def render_unauthorized
    render_message(
      message: I18n.t('errors.invalid_headers'),
      status: 401
    )
  end

  def render_decode_error
    render_message(
      message:  I18n.t('errors.invalid_api_key'),
      status: 401
    )
  end

  def render_message(message:, status: 200)
    response_hash = {}
    response_hash[:message] = message
    render json: response_hash, status: status
  end

  def send_user_response result
    result[:user].update_tracked_fields!(request)
    render json: {
      data: V1::UserSerializer.new(result[:user], be_trendy: true).as_json,
      token: ApiKeyHandler.encoded_api_key(result[:user][:id]),
      message: I18n.t('success.action', action: 'login')
    }
  end

  def _run_options(options)
    options.merge!(current_user: current_user)
  end

  def pagination_hash(total_count, current_count)
   return {
      page: (params[:page].presence || '1'),
      limit: (params[:limit].presence || '10'),
      total_records: total_count,
      current_records: current_count
    }
  end

  def log_user_actions
    if params[:token].present? 
      trigger = ''
      user = User.find_by(email: params[:email])
      
      email_trigger = EmailTracker.find(params[:triggerId])
      trigger = email_trigger.mail_trigger if email_trigger.present?
      
      logging_action = ActionLogger.new({
        user: user,
        action: 'Logged In',
        event_id: email_trigger.present? ? email_trigger.event_id : "",
        is_token: true,
        trigger: trigger
      })

      if logging_action.valid?
        logging_action.save!
      end
    elsif params[:controller] == "v1/sessions" and 
      params[:action] == "create" and 
      params[:email].present? and 
      params[:password].present?

      user = User.find_by(email: params[:email])
      if request.headers['Frontend-Params'].present?
        frontend_params = request.headers['Frontend-Params'].gsub('?', "")
        fp = frontend_params.split('&')

      else
        logging_action = ActionLogger.create({
          user: user,
          action: 'Logged In',
        })
      end
      
    elsif params[:controller] == "v1/events" and 
      params[:action] == "index" and 
      request.headers['Frontend-Route'] == "/organizer/event-management" and 
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Add/Edit Events',
      })

    elsif params[:controller] == "v1/speaker_calls" and 
      params[:action] == "speaker_call_events" and
      request.headers['Frontend-Route'] == "/organizer/find-a-speaker" and 
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Find A Speaker',
      })
    elsif params[:controller] == "v1/dashboards" and 
      params[:action] == "organizer" and
      request.headers['Frontend-Route'] == "/organizer" and 
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Dashboard',
      })

    elsif params[:controller] == "v1/events" and 
      params[:action] == "unclaimed_events" and
      request.headers['Frontend-Route'] == "/organizer/claim-events" and
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Claim Events',
      })
    elsif params[:controller] == "v1/event_contents" and 
      params[:action] == "organizer_event_list" and
      request.headers['Frontend-Route'] == "/organizer/event-content-management" and
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Event Content Management',
      })

    elsif params[:controller] == "v1/events" and 
      params[:action] == "index" and
      request.headers['Frontend-Route'] == "/organizer/review-management" and
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited All Reviews',
      })

    elsif params[:controller] == "v1/reviews" and 
      params[:action] == "saved_reviews" and
      request.headers['Frontend-Route'] == "/organizer/saved-reviews" and
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Bookmarked Reviews',
      })

    elsif params[:controller] == "v1/events" and 
      params[:action] == "organizer_events" and
      request.headers['Frontend-Route'] == "/organizer/acquire-more-reviews" and
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Acquire Reviews',
      })

    elsif params[:controller] == "v1/events" and 
      params[:action] == "generate_campaign_link" and
      request.headers['Frontend-Route'] == "/organizer/acquire-more-reviews" and
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        event_id: params[:id],
        action: 'Generated Campaign Link',
      })

    elsif params[:controller] == "v1/dashboards" and 
      params[:action] == "organizer_event_list" and
      request.headers['Frontend-Route'] == "/organizer/rating-badges" and 
      request.headers["Authorization"].present?
      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited All Badges',
      })

    elsif params[:controller] == "v1/dashboards" and 
      params[:action] == "organizer_event_list" and
      request.headers['Frontend-Route'] == "/organizer/embed-audio-reviews" and 
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Embed Audio Reviews',
      })

    elsif params[:controller] == "v1/speaker_calls" and 
      params[:action] == "speaker_call_events" and
      request.headers['Frontend-Route'] == "/organizer/find-a-speaker" and 
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Visited Find a Speaker',
      })

    elsif params[:controller] == "v1/speaker_calls" and 
      params[:action] == "create" and
      request.headers['Frontend-Route'] == "/organizer/find-a-speaker" and 
      request.headers["Authorization"].present?

      if params[:event_id].present?
        logging_action = ActionLogger.create({
          user: current_user,
          event_id: params[:event_id],
          action: 'Created Speaker Call',
        })
      elsif params[:event_source] == "custom"
        logging_action = ActionLogger.create({
          user: current_user,
          action: 'Created Speaker Call - Unlisited Event',
        })
      end

    elsif params[:controller] == "v2/visitor_details" and 
      params[:action] == "visitor_detail_list" and
      request.headers['Frontend-Route'] == "/organizer/visitor-data" and 
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        event_id: params[:event_id],
        action: 'Visited Visitor Data',
      })
    elsif params[:controller] == "v1/events" and 
      params[:action] == "post_analysis_report_list" and
      request.headers['Frontend-Route'] == "/organizer/reports" and 
      request.headers["Authorization"].present?

      logging_action = ActionLogger.create({
        user: current_user,
        event_id: params[:event_id],
        action: 'Visited Reports',
      })
    elsif params[:controller] == "v1/users" and
      params[:action] == "show" and
      request.headers['Frontend-Params'].present? and 
      request.headers["Authorization"].present?
      triggerId = ""
      frontend_params = request.headers['Frontend-Params'].gsub('?', "")
      fp = frontend_params.split('&')

      fp.each do |entry| 
        if entry.include?('triggerid')
          triggerId = entry.split('=').last
        end
      end

      trigger = EmailTracker.find(triggerId)
      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Logged In',
        event_id: trigger.present? ? trigger.event_id : "",
        trigger: trigger.present? ? trigger.mail_trigger : "",
      })
    elsif params[:controller] == "v1/events" and
      params[:action] == "show" and
      request.headers['Frontend-Route'].include?("/organizer/event/edit") and 
      request.headers["Authorization"].present? and 
      params[:id].present?

      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Viewed Event Edit Page',
        event_id: params[:id]
      })
    elsif params[:controller] == "v1/claim_requests" and
      params[:action] == "create" and
      request.headers['Frontend-Route'] == "/organizer/claim-events" and 
      request.headers["Authorization"].present? and 
      params[:event_id].present?
      logging_action = ActionLogger.create({
        user: current_user,
        action: 'Claimed Event',
        event_id: params[:event_id]
      })
    end
  end
end
