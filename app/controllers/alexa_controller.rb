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
      r.spoken_response = "Are you ready for a quiz?"
    elsif @echo_request.intent_name == "AMAZON.StartOverIntent"
      @newQuestion = deck.getSample
      r.spoken_response = "You chose to start over. Here is your next flashcard: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}"
    elsif @echo_request.intent_name == "DontKnowIntent"
      r.spoken_response = "The answer is #{deck.answers}. Next question."
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
