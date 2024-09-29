class GetVideoDetails < ApplicationJob

  def perform(links, profile_verification)
    youtube_url = links.present? ? links.split(", ") : nil
    
    unless youtube_url.present?
      profile_verification.update(youtube_url: nil)
      return
    end
        
    response_arr = []

    youtube_url.each do |url|
      video_source = if url.include?("youtube") 
        "youtube"
      elsif url.include?("vimeo")
        "vimeo"
      end

      begin
        response = if video_source == "youtube"
          HTTParty.get("https://www.youtube.com/oembed?url=#{url}&format=json")
        elsif video_source == "vimeo"
          HTTParty.get("https://vimeo.com/api/oembed.json?url=#{url}")
        end

        if response.empty?
          result = {
            title: "",
            author_name: "",
            thumbnail_url: "",
            embed_url: url, 
            watch_url: url
          }
          response_arr << result
          next
        end

        parsed_res = response.parsed_response

        result = {
          title: parsed_res["title"],
          author_name: parsed_res["author_name"],
          thumbnail_url: parsed_res["thumbnail_url"],
          embed_url: if video_source == "youtube" 
            "https://www.youtube.com/embed/#{parsed_res["thumbnail_url"].split("/")[-2]}"
            elsif video_source == "vimeo"
              "https://player.vimeo.com/video/#{parsed_res["video_id"]}"
            end,
          watch_url: if video_source == "youtube" 
            "https://www.youtube.com/watch?v=#{parsed_res["thumbnail_url"].split("/")[-2]}"
          elsif video_source == "vimeo"
            "https://vimeo.com/#{parsed_res["video_id"]}"
          end
        }

        response_arr << result

      rescue
        url_id = if video_source == "youtube"
          url.split("=")[1].split("&")[0]
        elsif video_source == "vimeo"
          url.split("/")[-1]
        end

        result = {
          title: "",
          author_name: "",
          thumbnail_url: "",
          embed_url: if video_source == "youtube" 
            "https://www.youtube.com/embed/#{url_id}"
          elsif video_source == "vimeo"
            "https://player.vimeo.com/video/#{url_id}"
          end,
          watch_url: if video_source == "youtube"
            "https://www.youtube.com/watch?v=#{url_id}"
          elsif video_source == "vimeo"
            "https://vimeo.com/#{url_id}"
          end
        }

        response_arr << result
      end  
    end
    
    profile_verification.update(youtube_url: response_arr)
  end
end