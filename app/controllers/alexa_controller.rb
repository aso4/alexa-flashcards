require 'alexa_web_service'
require 'httparty'
require 'json'
require 'staccato'

class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

    tracker = Staccato.tracker('UA-92171206-1')

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
      # Track an Event (all values optional)
      tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 1).track!

      r.end_session = true
      r.spoken_response = "Welcome to Ruby Flashcards. Are you ready to test your Ruby knowledge? Say new flashcard or help to begin."
    elsif @echo_request.intent_name == "AMAZON.StartOverIntent"
      tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 0).track!

      r.end_session = false
      r.spoken_response = "New card. Here is your next question: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}. You can say one, two, three, or four. For more response options, say help."
      r.reprompt_text = "sorry, I couldn't catch what you were saying.
      say the answer in a sentence. for example, the answer is one.
      you can also say i don’t know, skip, or repeat the question"
      add_session_attributes(r)
    elsif @echo_request.intent_name == "AMAZON.HelpIntent"
      tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 9).track!
      r.end_session = false
      @newQuestion = deck.getSample
      r.spoken_response = "help menu. to go to the main menu, say main menu or open main menu.
      to open a flashcard, you can say start, new flashcard, start new flashcard, or give me a new flashcard.
      once a flashcard is opened, you can say one, two, three or four.
      you can also say the answer in sentence form.
      for example, the answer is one, my answer is two, is it three?, or four is my answer.
      if you don’t know the answer or would like to skip, you can say i don’t know or skip.
      to repeat the question, say repeat, repeat the the question, say it again, or say the question again."
      add_session_attributes(r)
    elsif @echo_request.intent_name == "AnswerIntent" || @echo_request.intent_name == "AnswerOnlyIntent" || @echo_request.intent_name == "AMAZON.RepeatIntent" || @echo_request.intent_name == "DontKnowIntent"
      r.end_session = false
      if @echo_request.attributes["repeatQuestion"] != nil
        if @echo_request.intent_name == "AMAZON.RepeatIntent"
          tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 6).track!
          r.add_attribute("currentQuestionIndex", @echo_request.attributes["currentQuestionIndex"])
          r.add_attribute("correctAnswerText", @echo_request.attributes["correctAnswerText"])
          r.add_attribute("repeatQuestion", @echo_request.attributes["repeatQuestion"])
          r.add_attribute("correctAnswerIndex", @echo_request.attributes["correctAnswerIndex"])
          r.spoken_response = "#{@echo_request.attributes["repeatQuestion"]}"

        elsif @echo_request.attributes["correctAnswerIndex"] == @echo_request.slots.answer.to_i
          tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 2).track!
          @newQuestion = deck.getSample
          r.spoken_response = "That is correct! Next question: #{@newQuestion[2]}.
          What is the correct answer? #{@newQuestion[3].join(", ")}"
          r.reprompt_text = "sorry, I couldn't catch what you were saying.
          try saying the answer in a sentence. for example, the answer is one.
          you can also say i don’t know, skip, or repeat the question"
          r.card_title = "Correct Response"
          r.card_content = "#{@newQuestion[2]}\n The correct answer is #{@newQuestion[4]}"
          add_session_attributes(r)

        elsif @echo_request.intent_name == "DontKnowIntent" #alexa doesn't understand what you're saying
          tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 10).track!
          r.add_attribute("currentQuestionIndex", @echo_request.attributes["currentQuestionIndex"])
          r.add_attribute("correctAnswerText", @echo_request.attributes["correctAnswerText"])
          r.add_attribute("repeatQuestion", @echo_request.attributes["repeatQuestion"])
          r.add_attribute("correctAnswerIndex", @echo_request.attributes["correctAnswerIndex"])
          r.spoken_response = "sorry, I couldn't catch what you were saying.
          try saying the answer in a sentence. for example, the answer is one.
          you can also say i don’t know, skip, or repeat the question"
        else
          @newQuestion = deck.getSample
          tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 3).track!
          r.spoken_response = "Sorry, that is incorrect. The answer is #{@echo_request.attributes["correctAnswerIndex"]}, #{@echo_request.attributes["correctAnswerText"]}.
          Let's try another question: #{@newQuestion[2]}.
          What is the correct answer? #{@newQuestion[3].join(", ")}"
          r.reprompt_text = "sorry, I couldn't catch what you were saying.
          try saying the answer in a sentence. for example, the answer is one.
          you can also say i don’t know, skip, or repeat the question"
          r.card_title = "Incorrect Response."
          r.card_content = "#{@newQuestion[2]}\n The correct answer is #{@newQuestion[4]}"
          add_session_attributes(r)
        end
      else
        r.spoken_response = "ask me for a flashcard to begin. you can say new flashcard or help."
      end

    elsif @echo_request.session_ended_request?
      tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 8).track!
      r.end_session = true
      r.spoken_response = "session has ended"

    elsif @echo_request.intent_name == "AMAZON.StopIntent" ||  @echo_request.intent_name == "AMAZON.CancelIntent"
      tracker.build_event(category: 'intent', action: @echo_request.intent_name, value: 7).track!
      r.end_session = true
      r.spoken_response = "you have chosen to stop. session has ended"
    end

    render json: r.without_card
  end

  private
  def add_session_attributes(response)
    response.add_attribute("repeatQuestion", "#{@newQuestion[2]}. What is the correct answer? #{@newQuestion[3].join(", ")}")
    response.add_attribute("currentQuestionIndex", @newQuestion[0])
    response.add_attribute("correctAnswerIndex", @newQuestion[1])
    response.add_attribute("correctAnswerText", @newQuestion[4])
  end

  # def trackEvent(category, action, label, value, callback)
  #   data = {
  #     v: '1', # API version
  #     tid: env[GA_TRACKING_ID],
  #     cid: '555',
  #     t: 'event', # Event hit type
  #     ec: category, # Event category
  #     ea: action, # Event action
  #     el: label, # Event label
  #     ev: value # Event value
  #   }
  #
  #   # build post response
  #   post 'http://www.google-analytics.com/collect', {
  #     form: data
  #   }
  #
  #   # error callback not included
  # end
  #
  # def ga
  #   POST /collect HTTP/1.1
  #   Host: www.google-analytics.com
  #   #v = 1
  #   #t = 'event'
  #   #tid = 'UA-92171206-1'
  #   #cid = '555'
  #   ec = 'video'
  #   el = 'holiday'
  #   ev = '300'
  # end



end
