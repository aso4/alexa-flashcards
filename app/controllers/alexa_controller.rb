require 'alexa_web_service'
require 'httparty'
require 'json'

class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

    @data = request.body.read
    params.merge!(JSON.parse(@data))
    @echo_request = AlexaWebService::AlexaRequest.new(JSON.parse(@data))
    @application_id = @echo_request.application_id
    deck = Flashcards.new

    # If the request body has been read, you need to rewind it.
    request.body.rewind
    AlexaWebService::AlexaVerify.new(request.env, request.body.read)

    # Uncomment this and include your skill id before submitting application for certification:
    # halt 400, "Invalid Application ID" unless @application_id == "your-skill-id"

    r = AlexaResponse.new

    if @echo_request.launch_request?
      r.spoken_response = "Welcome to Ruby Flashcards. Are you ready to test your knowledge?"
    elsif @echo_request.intent_name == "AMAZON.StartOverIntent"
      @newQuestion = deck.getSample
      r.spoken_response = "Starting over. Here is your next flashcard: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}"
    elsif @echo_request.intent_name == "DontKnowIntent"
      @newQuestion = deck.getSample
      r.spoken_response = "The answer is #{@newQuestion[4]}. Next question: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}"
    elsif @echo_request.intent_name == "AnswerIntent" || @echo_request.intent_name == "AnswerOnlyIntent"
      if true #@echo_request.slots.answer == @newQuestion[1]
        logger.info "SLOTS ARE: #{@echo_request.slots}"
        logger.info "STRUCT ANSWER: #{@echo_request.slots.answer}"
        @newQuestion = deck.getSample
        r.spoken_response = "That is correct! Next question: #{@newQuestion[2]}.
        What is the correct answer? #{@newQuestion[3].join(", ")}"
      else
        r.spoken_response = "Sorry, that is incorrect. The answer is #{@newQuestion[1]}, #{@newQuestion[4]}.
        Let's try another question: #{@newQuestion[2]}.
        What is the correct answer? #{@newQuestion[3].join(", ")}"
      end
    elsif @echo_request.session_ended_request?
      r.end_session = true
    elsif @echo_request.intent_name == "AMAZON.StopIntent" ||  @echo_request.intent_name == "AMAZON.CancelIntent"
      r.end_session = true
    end
    r.end_session ||= false
    render json: r.with_card
  end

  def show
    render "The Alexa Flashcards: Ruby server is up and running!"
  end
end
