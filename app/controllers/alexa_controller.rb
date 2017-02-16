require 'alexa_web_service'
require 'httparty'
require 'json'

class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

    @data = request.body.read
    params.merge!(JSON.parse(@data))
    @echo_request = AlexaRequest.new(JSON.parse(@data))
    @application_id = @echo_request.application_id
    deck = Flashcards.new

    # If the request body has been read, you need to rewind it.
    request.body.rewind
    AlexaWebService::AlexaVerify.new(request.env, request.body.read)

    # Uncomment this and include your skill id before submitting application for certification:
    # halt 400, "Invalid Application ID" unless @application_id == "your-skill-id"

    r = AlexaResponse.new
    @newQuestion = deck.getSample

    if @echo_request.intent_name == "LaunchIntent"
      r.spoken_response = "Welcome to Ruby Flashcards. Are you ready to test your Ruby knowledge? Say new flashcard, or help to begin."

    elsif @echo_request.intent_name == "AMAZON.StartOverIntent"
      r.end_session = false
      r.spoken_response = "New card. Here is your next question: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}. You can say one, two, three, or four. For more response options, say help."
      r.reprompt_text = "sorry, I couldn't catch what you were saying.
      say the answer in a sentence. for example, the answer is one.
      you can also say i don’t know, skip, or repeat the question"
      add_session_attributes(r)

    elsif @echo_request.intent_name == "DontKnowIntent" #alexa doesn't understand what you're saying
      r.end_session = false
      r.add_attribute("currentQuestionIndex", @echo_request.attributes["currentQuestionIndex"])
      r.add_attribute("correctAnswerText", @echo_request.attributes["correctAnswerText"])
      r.add_attribute("repeatQuestion", @echo_request.attributes["repeatQuestion"])
      r.add_attribute("correctAnswerIndex", @echo_request.attributes["correctAnswerIndex"])
      r.spoken_response = "sorry, I couldn't catch what you were saying.
      try saying the answer in a sentence. for example, the answer is one.
      you can also say i don’t know, skip, or repeat the question"

    elsif @echo_request.intent_name == "AMAZON.HelpIntent"
      r.end_session = false
      @newQuestion = deck.getSample
      r.spoken_response = "help menu. to go to the main menu, say main menu, or open main menu.
      to open a flashcard, you can say start, new flashcard, start new flashcard, or give me a new flashcard.
      once a flashcard is opened, you can say one, two, three or four.
      you can also say the answer in sentence form.
      for example, the answer is one, my answer is two, is it three?, or four is my answer.
      if you don’t know the answer or would like to skip, you can say i don’t know or skip.
      to repeat the question, say repeat, repeat the the question, say it again, or say the question again."
      add_session_attributes(r)

    elsif @echo_request.intent_name == "AnswerIntent" || @echo_request.intent_name == "AnswerOnlyIntent" || @echo_request.intent_name == "AMAZON.RepeatIntent"
      if @echo_request.session_attributes?

        if @echo_request.intent_name == "AMAZON.RepeatIntent"
          r.end_session = false
          r.add_attribute("currentQuestionIndex", @echo_request.attributes["currentQuestionIndex"])
          r.add_attribute("correctAnswerText", @echo_request.attributes["correctAnswerText"])
          r.add_attribute("repeatQuestion", @echo_request.attributes["repeatQuestion"])
          r.add_attribute("correctAnswerIndex", @echo_request.attributes["correctAnswerIndex"])
          r.spoken_response = "#{@echo_request.attributes["repeatQuestion"]}"

        elsif @echo_request.attributes["correctAnswerIndex"] == @echo_request.slots.answer.to_i
          r.end_session = false
          @newQuestion = deck.getSample
          r.spoken_response = "That is correct! Next question: #{@newQuestion[2]}.
          What is the correct answer? #{@newQuestion[3].join(", ")}"
          r.reprompt_text = "sorry, I couldn't catch what you were saying.
          try saying the answer in a sentence. for example, the answer is one.
          you can also say i don’t know, skip, or repeat the question"
          r.card_title = "Correct!"
          r.card_content = "#{@newQuestion[2]}\n The correct answer is #{@newQuestion[4]}"
          add_session_attributes(r)

        else
          r.end_session = false
          @newQuestion = deck.getSample
          r.spoken_response = "Sorry, that is incorrect. The answer is #{@echo_request.attributes["correctAnswerIndex"]}, #{@echo_request.attributes["correctAnswerText"]}.
          Let's try another question: #{@newQuestion[2]}.
          What is the correct answer? #{@newQuestion[3].join(", ")}"
          r.reprompt_text = "sorry, I couldn't catch what you were saying.
          try saying the answer in a sentence. for example, the answer is one.
          you can also say i don’t know, skip, or repeat the question"
          r.card_title = "Sorry, that's incorrect."
          r.card_content = "#{@newQuestion[2]}\n The correct answer is #{@newQuestion[4]}"
          add_session_attributes(r)
        end
      else
        logger.info "session data was lost"
        r.spoken_response = "session data was lost"
      end

    elsif @echo_request.session_ended_request?
      r.end_session = true
      r.spoken_response = "session has ended"

    elsif @echo_request.intent_name == "AMAZON.StopIntent" ||  @echo_request.intent_name == "AMAZON.CancelIntent"
      r.end_session = true
      r.spoken_response = "you have chosen to stop. session has ended"
    end

    r.end_session ||= false
    #r.spoken_response = "session has ended. say main menu, new flashcard, or help to begin again." #this line is causing problems
    render json: r.without_card
  end

  def show
    render "The Alexa Flashcards: Ruby server is up and running!"
  end

  private
  def add_session_attributes(response)
    response.add_attribute("repeatQuestion", "#{@newQuestion[2]}. What is the correct answer? #{@newQuestion[3].join(", ")}")
    response.add_attribute("currentQuestionIndex", @newQuestion[0])
    response.add_attribute("correctAnswerIndex", @newQuestion[1])
    response.add_attribute("correctAnswerText", @newQuestion[4])
  end


end
