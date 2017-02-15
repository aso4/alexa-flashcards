require 'alexa_web_service'
require 'httparty'
require 'json'
#require 'google/apis/analytics_v3'
#require 'signet/oauth_2/client'

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
    @newQuestion = deck.getSample

    if @echo_request.intent_name == "LaunchIntent"
      logger.info "onLaunch requestId= #{@echo_request.request_id}, sessionId= #{@echo_request.session_id}"
      r.spoken_response = "Welcome to Ruby Flashcards. Are you ready to test your Ruby knowledge? Say new flashcard, or help to begin."

    elsif @echo_request.intent_name == "AMAZON.StartOverIntent"
      r.end_session = false
      r.spoken_response = "New card. Here is your next question: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}. You can say one, two, three, or four. For more response options, say help."
      r.reprompt_text = "sorry, I couldn't catch what you were saying.
      say the answer in a sentence. for example, the answer is one.
      you can also say i don’t know, skip, or repeat the question"
      add_session_attributes(r)

    elsif @echo_request.intent_name == "DontKnowIntent"
      r.end_session = false
      @newQuestion = deck.getSample
      r.spoken_response = "The answer is #{@newQuestion[4]}. Next question: #{@newQuestion[2]}.
      What is the correct answer? #{@newQuestion[3].join(", ")}"
      r.reprompt_text = "sorry, I couldn't catch what you were saying.
      try saying the answer in a sentence. for example, the answer is one.
      you can also say i don’t know, skip, or repeat the question"
      add_session_attributes(r)

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
          logger.info "ATTRIBUTES ARE: #{@echo_request.attributes}"
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
          r.card_content "#{@echo_request.attributes["repeatQuestion"]}\n#{@echo_request.attributes["correctAnswerText"]}"
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
          r.card_content "#{@echo_request.attributes["repeatQuestion"]}\nThe correct answer is #{@echo_request.attributes["correctAnswerText"]}"
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

    r.end_session ||= true
    r.spoken_response = "session has ended. say main menu, new flashcard, or help to begin again."
    render json: r.without_card
  end

  def show
    render "The Alexa Flashcards: Ruby server is up and running!"
  end

  def redirect
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GA_CLIENT_ID'),
      client_secret: ENV.fetch('GA_CLIENT_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::AnalyticsV3::AUTH_ANALYTICS_READONLY,
      redirect_uri: 'http://32acf0c3.ngrok.io/oauth2callback'
    })

    redirect_to client.authorization_uri.to_s
  end

  #@token = AccessToken.new('placeholder')
  #@code = ''

  def callback
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GA_CLIENT_ID'),
      client_secret: ENV.fetch('GA_CLIENT_SECRET'),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: 'http://32acf0c3.ngrok.io/oauth2callback',
      code: params['code']
    })

    #logger.info "CLIENT METHODS: #{client.methods}"
    #logger.info "CLIENT fetch_access_token CALLED: #{client.orig_fetch_access_token!}"
    #ya29.GlzzA_ZyewobSiiWLR057Dd3zHPQ7oxPJTBU-yz97mXrMnGKBQ8Qkkm0MPi9c_7E_D_MHSHl_zWlx_VItH0Mz9qn2AbGke5v1J7P3r__TsqZLmiE46cQAi_wOAovCA
    response = client.fetch_access_token!

    #@code = params['code']
    set_code(params['code'])
    #@token = AccessToken.new(response['access_token'])
    set_token(response['access_token'])
    logger.info "code: #{@code}"
    #logger.info "token is #{response}"
    logger.info "set_token #{@token}"
    #logger.info "params are #{params.as_json}" #param doesn't include access token.
    redirect_to url_for(:action => :analytics)
  end

  def analytics
    client = Signet::OAuth2::Client.new({
      access_token: @token, #'ya29.GlzzA8vMthZTdBm8rBTJEruO3QCrihTCpcmZylxML8r79PFaaJ56gYuzqq9P3re2DrlcpTja9UZOq9wnORZMe_QQzN3WmCjb82msGitMuckD2buu7vqi3oCe-l1qwA',
      expires_in: 3600
    })

    service = Google::Apis::AnalyticsV3::AnalyticsService.new

    service.authorization = client

    #logger.info "#analytics PARAMS: #{params.as_json}"
    #logger.info "SERVICE AUTHORIZATION #{service.authorization}"
    logger.info "TOKEN: #{@token}"
    #logger.info "SERVICE IS: #{service.authorization}"

    @account_summaries = service.list_account_summaries
  end

  attr_reader :token

  def set_token(token)
    @token = token
  end

  def set_code(code)
    @code = code
  end

  private
  def add_session_attributes(response)
    response.add_attribute("repeatQuestion", "#{@newQuestion[2]}. What is the correct answer? #{@newQuestion[3].join(", ")}")
    response.add_attribute("currentQuestionIndex", @newQuestion[0])
    response.add_attribute("correctAnswerIndex", @newQuestion[1])
    response.add_attribute("correctAnswerText", @newQuestion[4])
  end


end
