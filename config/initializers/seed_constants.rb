QUESTION_HASH =
  [{
    title:"Review Title - Please describe your experience in a short sentence",
    question_type: "text",
    display_order: 1,
    minimum_length: 10,
    maximum_length: 200,
    placeholder: "Please describe your experience in a short sentence."
  },
  {
    title:"What did you like best about the event?",
    question_type: "textarea",
    display_order: 2,
    minimum_length:10,
    maximum_length: 200,
    placeholder: "Your overall impression, something you really liked about the event, …"
  },
  {
    title:"What could the organizers do to improve the event?",
    question_type: "textarea",
    display_order: 3,
    minimum_length: 10,
    maximum_length: 200,
    placeholder: "Something that could have been better, something that could make this event more useful to you.."
  },
  {
    title:"How likely is it that you would recommend this event to a friend or colleague?",
    question_type: "scale_5",
    display_order: 4
  },
  {
    title: "Did you have a favourite speaker or session? Please tell us below",
    question_type: "text",
    question_for: "attendee",
    display_order: 6,
    placeholder: "Your favourite speaker or session..."
  }]

ATTENDEE_QUESTIONS =
  [{
    title: "Overall experience",
    question_type: "rating_5",
    display_order: 1
  },
  {
    title: "Value for money",
    question_type: "rating_5",
    display_order: 2
  },
  {
    title: "Networking opportunities",
    question_type: "rating_5",
    display_order: 3
  },
  {
    title: "Usefulness of participating vendors/sponsors",
    question_type: "rating_5",
    display_order: 4
  },
  {
    title: "Session(s)",
    question_type: "rating_5",
    display_order: 5
  },
  {
    title: "Amount of new information learned",
    question_type: "rating_5",
    display_order: 6
  }]

SPEAKER_QUESTIONS=
  [{
    title: "Overall experience",
    question_type: "rating_5",
    display_order: 1
  },
  {
    title: "Networking opportunities",
    question_type: "rating_5",
    display_order: 2
  },
  {
    title: "Technical support for setting up the session",
    question_type: "rating_5",
    display_order: 3
  },
  {
    title: "Interactivity with the audience",
    question_type: "rating_5",
    display_order: 4
  },
  {
    title: "Quality of the audience",
    question_type: "rating_5",
    display_order: 5
  }]

SPONSOR_QUESTIONS =
  [{
    title: "Overall experience",
    question_type: "rating_5",
    display_order: 1
  },
  {
    title: "Engagement opportunities with the audience",
    question_type: "rating_5",
    display_order: 2 
  },
  {
    title: "Fit of the audience for my company",
    question_type: "rating_5",
    display_order: 3
  },
  {
    title: "ROI on spend",
    question_type: "rating_5",
    display_order: 4
  },
  {
    title: "Positive brand exposure",
    question_type: "rating_5",
    display_order: 5
  }]
ONLINE_COMMON_QUESTIONS = 
  [{
    title: "Navigation of virtual platform",
    question_type: "rating_5",
    display_order: 1
  },
  {
    title: "Troubleshooting technical issues",
    question_type: "rating_5",
    display_order: 2
  }]

IN_PERSON_COMMON_QUESIONS = 
  [{
    title: "Event destination",
    question_type: "rating_5",
    display_order: 1
  },
  {
    title: "Event venue",
    question_type: "rating_5",
    display_order: 2
  },
  {
    title: "Food and beverages at event",
    question_type: "rating_5",
    display_order: 3
  },
  {
    title: "Helpfulness of event staff",
    question_type: "rating_5",
    display_order: 4
  }]
