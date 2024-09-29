# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.find_or_create_by(name: "Eventible Admin", email: "admin@eventible.com", encrypted_password: "$2a$12$HTuNrHCTKh3hJbiCG.VSte1uvXf0LUJFoYdkZapG8t/piwP223Mqy", role: 'admin')
job_tile_hash =
  [{
    name: "HR",
    display_order: 2
  },
  {
    name: "Marketing",
    display_order: 1
  },
  {
    name: "Finance",
    display_order: 4

  },
  {
    name: "IT",
    display_order: 3

  }]
country_name_hash =
 [{
    name: "United States",
    code: "US",
    display_order: 1
  },
  {
    name: "United Kingdom",
    code: "UK",
    display_order: 2
  },
  {
    name: "Hong Kong",
    code: "HKG"
  },
  {
    name: "Slovakia",
    code: "SVK"
  },
  {
    name: "Philippines",
    code: "PHL"
  },
  {
    name: "Spain",
    code: "ESP"
  },
  {
    name: "UAE",
    code: "UAE"
  },
  {
    name: "Sweden",
    code: "SWE"
  },
  {
    name: "Australia",
    code: "AUS"
  },
  {
    name: "Germany",
    code: "DEU"
  },
  {
    name: "Singapore",
    code: "SGP"
  },
  {
    name: "France",
    code: "FRA"
  },
  {
    name: "Georgia",
    code: "GEO"
  },
  {
    name: "Other",
    display_order: 1000
  }]

job_tile_hash.each {|job_title| JobTitle.find_or_create_by(job_title) }
country_name_hash.each {|country| Country.find_or_create_by(country) }


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

admin_user = User.find_or_initialize_by(name: "Ankush Gupta", email: "ag@eventible.com", role: 'admin')
if admin_user.new_record?
  admin_user.password="josh1234"
  admin_user.skip_confirmation_notification!
  admin_user.skip_invitation
  admin_user.save!
end
organizer_user = User.find_or_initialize_by(name: "Eventible Organizer", email: "organizer@eventible.com", role: 'organizer')
if organizer_user.new_record?
  organizer_user.password="josh1234"
  organizer_user.skip_confirmation_notification!
  organizer_user.skip_invitation
  organizer_user.save!
end
moderator_user = User.find_or_initialize_by(name: "Eventible Moderator", email: "moderator@eventible.com", role: 'moderator')
if moderator_user.new_record?
  moderator_user.password="josh1234"
  moderator_user.skip_confirmation_notification!
  moderator_user.skip_invitation
  moderator_user.save!
end

industries =
  [{
    name: 'Customer Experience'
  },
  {
    name: 'Finance and Investments'
  },
  {
    name: 'Healthcare'
  },
  {
    name: 'Human Resource'
  }]
industries.each {|industry| Industry.find_or_create_by(industry) }
