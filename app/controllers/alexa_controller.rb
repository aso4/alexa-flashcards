require 'alexa_web_service'
require 'httparty'
require 'json'

class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

    @data = request.body.read
    params.merge!(JSON.parse(@data))
    #@echo_request = AlexaWebService::AlexaRequest.new(JSON.parse(@data))
    @echo_request = AlexaRequest.new(JSON.parse(@data))
    @application_id = @echo_request.application_id
    deck = Flashcards.new

    # If the request body has been read, you need to rewind it.
    request.body.rewind
    AlexaWebService::AlexaVerify.new(request.env, request.body.read)

    # Uncomment this and include your skill id before submitting application for certification:
    # halt 400, "Invalid Application ID" unless @application_id == "your-skill-id"

    r = AlexaResponse.new
    @newQuestion = deck.getSample #moved from StartOverIntent

    if @echo_request.intent_name == "LaunchIntent"
      #logger.info "ATTRIBUTES ARE: #{@echo_request.application_id} #{@echo_request.user_id} #{@echo_request.access_token} #{@echo_request.session_id}"
      logger.info "onLaunch requestId= #{@echo_request.request_id}, sessionId= #{@echo_request.session_id}"
      r.spoken_response = "Welcome to Ruby Flashcards. Are you ready to test your Ruby knowledge?"

    elsif @echo_request.intent_name == "AMAZON.StartOverIntent"
      r.end_session = false
      r.spoken_response = "Starting over. Here is your next flashcard: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}"
      add_session_attributes(r)
    elsif @echo_request.intent_name == "DontKnowIntent"
      @newQuestion = deck.getSample
      r.spoken_response = "The answer is #{@newQuestion[4]}. Next question: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}"
      add_session_attributes(r)
    elsif @echo_request.intent_name == "AnswerIntent" || @echo_request.intent_name == "AnswerOnlyIntent"
      if @echo_request.session_attributes?
        #logger.info "session attributes registered"
        #logger.info "#{@echo_request.session_attributes?}"
        logger.info "#{@echo_request.attributes["correctAnswerIndex"]}"
        logger.info "#{@echo_request.slots.answer.to_i}" #this is the response
        if @echo_request.attributes["correctAnswerIndex"] == @echo_request.slots.answer.to_i
          r.end_session = false
          @newQuestion = deck.getSample
          r.spoken_response = "That is correct! Next question: #{@newQuestion[2]}.
          What is the correct answer? #{@newQuestion[3].join(", ")}"
          add_session_attributes(r)
        else
          r.end_session = false
          @newQuestion = deck.getSample
          r.spoken_response = "Sorry, that is incorrect. The answer is #{@echo_request.attributes["correctAnswerIndex"]}, #{@echo_request.attributes["correctAnswerText"]}.
          Let's try another question: #{@newQuestion[2]}.
          What is the correct answer? #{@newQuestion[3].join(", ")}"
          add_session_attributes(r)
        end
      else
        logger.info "session data was lost"
        r.spoken_response "session data was lost"
      end
    elsif @echo_request.session_ended_request?
      r.end_session = true
    elsif @echo_request.intent_name == "AMAZON.StopIntent" ||  @echo_request.intent_name == "AMAZON.CancelIntent"
      r.end_session = true
    end
    r.end_session ||= false
    render json: r.without_card
  end

  def show
    render "The Alexa Flashcards: Ruby server is up and running!"
  end

  private
  def add_session_attributes(response)
    response.add_attribute("reprompt", "#{@newQuestion[2]}. What is the correct answer? #{@newQuestion[3].join(", ")}")
    response.add_attribute("currentQuestionIndex", @newQuestion[0])
    response.add_attribute("correctAnswerIndex", @newQuestion[1])
    response.add_attribute("correctAnswerText", @newQuestion[4])
  end
end
