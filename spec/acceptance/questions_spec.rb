require 'spec_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'jwt'


resource 'Questitons' do
  let!(:question1) { create(:question) }
  let!(:question2) { create(:question, parent_id: question1.id) }
  let!(:option1) { create(:option, question_id: question1.id) }
  let!(:option2) { create(:option, question_id: question1.id) }
  let!(:question3) { create(:question, question_for: 'attendee') }

  before do
    header 'Accept', 'application/vnd.eventible.com; version=1'
    header 'Content-Type', 'application/json'
  end

  get '/questions' do
    example 'Question Listing' do
      explanation ' listing common questions'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/questions' do
    parameter :question_for, 'Question For [aatendee/speakers/sponsor]'
    let!(:question_for) { 'attendee' }
    let!(:raw_post) { params.to_json }

    example 'Specific Question Listing according to attend as attendee or speaker or sponsor' do
      explanation 'listing specific questions'
      do_request
      expect(status).to eq(200)
    end
  end

  get '/questions' do
    parameter :question_for, 'Question For [aatendee/speakers/sponsor]'
    let!(:question_for) { 'attend' }
    let!(:raw_post) { params.to_json }

    example 'If Pass invalid parameter of question_for' do
      explanation 'If Pass invalid parameter value'
      do_request
      expect(status).to eq(ERROR_STATUS_CODE)
    end
  end
end
