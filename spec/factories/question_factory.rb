FactoryBot.define do
  factory :question, class: Question do
    before(:create) do
      QUESTION_HASH.each { |question| Question.find_or_create_by(question) }

      question =
        Question.create({
          title: "Using the scale provided, please rate the event on the following aspects:",
          question_type: "matrix",
          question_for: "attendee",
          display_order: 5
        })
      ATTENDEE_QUESTIONS.each { |sub_question| question.sub_questions.find_or_create_by(sub_question)  }      

      question =
        Question.create({
          title: "Using the scale provided, please rate the event on the following aspects:",
          question_type: "matrix",
          question_for: "speaker",
          display_order: 5
        })
      SPEAKER_QUESTIONS.each { |sub_question| question.sub_questions.find_or_create_by(sub_question)  } 

      question =
        Question.create({
          title: "Using the scale provided, please rate the event on the following aspects:",
          question_type: "matrix",
          question_for: "sponsor",
          display_order: 5
        })
      SPONSOR_QUESTIONS.each { |sub_question| question.sub_questions.find_or_create_by(sub_question)  }      

      question = 
        Question.find_or_create_by(
          {
            title: "Rate the following points based on your attendance",
            question_type: "matrix",
            question_for: "common",
            mode_of_attendance: "online",
            display_order: 7
          })
      ONLINE_COMMON_QUESTIONS.each { |sub_question| question.sub_questions.find_or_create_by(sub_question) }      
      
      question =
        Question.find_or_create_by(
          {
            title: "Rate the following points based on your attendance",
            question_type: "matrix",
            question_for: "common",
            mode_of_attendance: "in_person",
            display_order: 7
          })
      IN_PERSON_COMMON_QUESIONS.each { |sub_question| question.sub_questions.find_or_create_by(sub_question) }      
    end
  end
end
