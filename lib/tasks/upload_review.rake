require 'csv'
namespace :reviews do
  desc "upload reviews pass the file as argument"   
  task :populate, %i[file_name] => :environment do|_task, args|
    abort('Only .csv file supported') unless /.csv/.match? args[:file_name]
    file_path = Rails.root.join('public','reviews',  args[:file_name])
    table = CSV.parse(File.read(file_path).scrub, headers: true)
    abort("CSV file headers should be #{table.headers}in this format") unless check_valid_headers?(table.headers)
    begin
      ActiveRecord::Base.transaction do
        table.each do |record|
          @record = record
          result = V1::Review::Operation::Create.call(params: ActionController::Parameters.new(fill_json_values(record)))
        end
      end
    rescue StandardError => e
      print "#{e} for this record #{@record}"
      print e.backtrace
      # Rollbar.error("#{e} for this record #{@record}")
    end
  end
end

def check_valid_headers?(headers)
  table1 = CSV.parse(File.read("public/reviews/sample_file.csv"), headers: true)
  table1.headers.sort == headers.sort
end

def fill_json_values(record)
  { 
    create_account: false,
    event_id: find_event_by_title(record["event name"].squish).id,
    attended_as: record["attended_as"].squish,
    mode_of_attendance: record["mode_of_attendance"],
    utm_source: 'web',
    submission_time: calculate_datetime(record),
    user: {
      name: full_name(record),
      email: record["email"]
    },
    answers: get_answers_array_of_hash(record)
  }
end

def find_event_by_title name
  Event.where("title ILIKE (?)", name).first
end

def full_name record
  "#{record['first_name']} #{record['last_name']}".downcase
end

def get_answers_array_of_hash(record)
  answers = []
  answers << load_overall_question(record)
  answers << load_networking_question(record) unless record["attended_as"].eql?('sponsor/vendor')
  answers << load_recommend_question_answer(record)
  answers << common_questions_answer(record)
  answers << attendance_mode_question_answers(record)
  answers << sub_questions_answers(record)
  answers.flatten
end

def attendance_mode_question_answers(record)
  answers = []
  attendance_mode_question = Question.where(title: "Rate the following points based on your attendance", mode_of_attendance: record["mode_of_attendance"]).first
  sub_questions = attendance_mode_question.sub_questions.pluck(:id, :title)
  sub_questions.each_with_index do|sub_question, index|
    answers << { answer: record[sub_question[1]].split("=")[0], question_id: sub_question[0] }
  end
  answers
end

def sub_questions_answers(record)
  answers = []
  specific_questions = Question.where(question_for: record['attended_as'].squish.split("/")[0]).order(:display_order)
  specific_questions.each do|question|
    sub_questions = question.sub_questions.where.not(title: ['Overall experience', 'Networking opportunities']).order(:display_order).pluck(:id, :title)
    sub_questions.each_with_index do|sub_question, index|
      print record[sub_question[1].squish].split("=")[0].squish
      answers << { answer: record[sub_question[1].squish].split("=")[0].squish, question_id: sub_question[0] }
    end
  end
  answers
end

def common_questions_answer(record)
  answers = []
  common_questions = Question.where(question_type: ['text','textarea']).order(:display_order).pluck(:title, :id)
  common_questions.each_with_index do|val, index|
    answers << { answer: record[val[0]], question_id: val[1] }
  end
  answers
end

def load_recommend_question_answer(record)
  recommend_question = Question.find_by(title: "How likely is it that you would recommend this event to a friend or colleague?")
  rating = record[recommend_question.title].split("=")[0].to_i
  scale =
    if rating.zero?
      1
    else
      rating/2 + rating%2
    end
  { answer: scale, question_id: recommend_question.id }
end

def load_overall_question(record)
  question = Question.where(title: "Using the scale provided, please rate the event on the following aspects:", question_for: record["attended_as"].squish.split("/")[0]).first
  overall_question = question.sub_questions.where(title:"Overall experience").first
  overall_string =
    if record["attended_as"].squish.eql?('attendee')
      "Overall experience"
    elsif record["attended_as"].squish.eql?("speaker")
      "Overall experience(speaker)"
    else
      "Overall experience(sponsor)"
    end
  { answer: record[overall_string].split("=")[0], question_id: overall_question.id}
end

def load_networking_question(record)
  question = Question.where(title: "Using the scale provided, please rate the event on the following aspects:", question_for: record["attended_as"].squish.split("/")[0]).first
  networking_question = question.sub_questions.where(title:"Networking opportunities").first
  networking_string =
    if record["attended_as"].squish.eql?('attendee')
      "Networking opportunities(attendee)"
    elsif record["attended_as"].squish.eql?('speaker')
      "Networking opportunities(speaker)"
    end
  { answer: record[networking_string].split("=")[0], question_id: networking_question.id}
end

def calculate_datetime(record)
  ((record["end_date"].to_datetime - record["start_date"].to_datetime) * 24 * 60).to_i
end