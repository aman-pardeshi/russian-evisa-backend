module Eventable
  extend ActiveSupport::Concern

  included do
    scope :left_join_on_first_user_insight, ->(user_id) do
      joins(
        # left join on first user insight
        <<-QUERY
          LEFT JOIN user_insights ON events.id = user_insights.resource_id
          AND user_insights.resource_type = 'Event'
          AND user_insights.id = (
            SELECT user_insights.id
            FROM user_insights
            WHERE user_insights.resource_id = events.id
            AND user_insights.resource_type = 'Event'
            AND user_insights.user_id = #{user_id}
            ORDER BY user_insights.id ASC
            LIMIT 1
          )
        QUERY
      )
    end

    scope :select_latest_campaign_links, ->(created_for, limit) do
      frontent_url = ENV.fetch("FRONTEND_URL")

      select(
        <<-QUERY
          COALESCE(
            (
              SELECT JSON_AGG(item)
              FROM (
                SELECT campaign_links.id AS id, campaign_links.reward_amount AS reward_amount,
                  campaign_links.expiry_date, (
                    CASE
                    WHEN campaign_links.created_for = 'admin'
                      THEN '#{frontent_url}/' ||
                        COALESCE(events.url_name, REPLACE(events.title, ' ', '')) ||
                        '/' ||
                        campaign_links.url_id
                    ELSE
                      '#{frontent_url}/review/' ||
                      COALESCE(events.url_name, REPLACE(events.title, ' ', '')) ||
                      '/' ||
                      campaign_links.url_id ||
                      '?utm_source=pre_campaign&utm_medium=referral&utm_campaign=' ||
                      events.slug
                    END
                  ) AS link
                FROM campaign_links
                WHERE campaign_links.event_id = events.id
                AND campaign_links.created_for = '#{created_for}'
                ORDER BY campaign_links.created_at DESC
                LIMIT #{limit}
              ) item
            ),
            '[]'
          )AS #{created_for}_camp_links
        QUERY
      )
    end

    scope :select_coupons, -> do
      select(
        # select coupons
        <<-QUERY
          COALESCE(
            (
              SELECT JSON_AGG(item)
              FROM (
                SELECT coupons.id, coupons.name, coupons.description,
                  coupons.discount_percentage, coupons.registration_url, coupons.validity
                FROM coupons
                WHERE coupons.event_id = events.id
              ) item
            ),
            '[]'
          ) AS event_coupons
        QUERY
      )
    end
  end
end