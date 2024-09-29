namespace "aws_keywords_for_reviews" do
  desc "Update the keywords for all the reviews"
  task aws_keyword_update_task: :environment do 
    e_id = Event.where('total_review > ?',9).pluck(:id)
    reviews_array = []
    e_id.each do |e|
      data = Review.where(status: 'approved', event_id: e)
      data.each do |d|
      reviews_array << d.id
      end
    end
      
    question_array = [1,2,3,5]
    reviews_array.each do |r_id|
      question_array.each do |q_id|
        data = ReviewSubmission.where(review_id: r_id, question_id: q_id).first

        if data.present?
          content = data.answer
          if content.present?
            value = get_key_phrases(content.gsub(/[,.“”]/ ,""))
            if value.present?
              value.each do |tmp|
                a = {
                  event_id: Review.where(id:r_id,status: 'approved').first.event_id,
                  review_id:r_id,
                  score: tmp.score,
                  keyword: tmp.text,
                  start_offset: tmp.begin_offset,
                  end_offset: tmp.end_offset,
                  question_id: q_id,
                  frequency: word_frequency(tmp.text,r_id),
                  duplicate_flag: nil
                }
                word_exclude(a)
              end
            end
          end
        end
      end
    end
      pp 'Keywords Saved!'
  end
end

def entity_extractor_client
  @entity_extractor_client ||= AwsComprehend.new
end
   
def get_key_phrases(content)
  entity_extractor_client.extract(content, 'en')
end
  
def word_frequency(word,r_id)
  count = ReviewSubmission.where(review_id: r_id, question_id: [1,2,3,5]).pluck(:answer).join(" ").gsub(/[^0-9A-Za-z]/, ' ').scan(/\b#{word.downcase.gsub(/[^0-9A-Za-z]/, ' ')}\b/i).count
  return count
end


def word_exclude(word_arr)

 if EXCLUDED_KEYWORDS.include?(word_arr[:keyword].downcase)
 else
    puts word_arr
    filter_words(word_arr)
 end

end

def filter_words(word_arr)
  b_arr = []
  data = word_arr[:keyword].split
  a =[]
  data.each do |d|
    if ['the','a','more', 'this', 'these', 'of', 'an', 'at', 'my','all' , 'The','A','many', 'that','miss'].include?(d)
      next
    else
      a << d
    end
  end
  b_arr << a.join(' ')
  word_arr[:keyword] = b_arr.first

  final_word_save(word_arr)
 
end

def final_word_save(word_arr)
  record = AwsKeywordReview.where(event_id: word_arr[:event_id], keyword: word_arr[:keyword])

  if record.present?
    similar_words = AwsKeywordReview.where('lower(keyword) like ?', "%#{word_arr[:keyword].downcase}%" )
    similar_words.each do |sw|
      if record.first.frequency > sw[:frequency]
        
        AwsKeywordReview.where(event_id: sw[:event_id], keyword: sw[:keyword]).update(duplicate_flag: true)
        AwsKeywordReview.where(event_id: record.first.event_id, keyword: record.first.keyword).update(duplicate_flag: false)
          # awskeywordreview.delete_by(event_id: record.first.event_id, keyword: record.first.keyword)
      
      elsif sw[:frequency] > record.first.frequency
        
        AwsKeywordReview.where(event_id: record.first.event_id, keyword: record.first.keyword).update(duplicate_flag: true)
        AwsKeywordReview.where(event_id: sw[:event_id], keyword: sw[:keyword]).update(duplicate_flag: false)
      end
    end
  else
    if word_arr[:keyword] == ""
    else
      begin
      awskeywordreview = AwsKeywordReview.new(word_arr)
      awskeywordreview.save!
      rescue ActiveRecord::RecordInvalid
        
      end
    end
  end
end
