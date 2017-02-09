#require 'net/http'
#require 'alexa_skills_ruby'
require 'alexa_web_service'

class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

    # request = AlexaWebService.new(application_id: 'amzn1.ask.skill.8fd7504e-1979-4837-81cc-82db38a26f02', logger: logger)

    # If the request body has been read, like in the Eight Ball example,
    # you need to rewind it.
    request.body.rewind

    # Verify the request.
    verified = AlexaWebService::AlexaVerify.new(request.env, request.body.read).verify_request
    halt 400, "#{verified}" unless verified == "OK"

    begin

      @echo_request = AlexaWebService::AlexaRequest.new(request_json)
      response = AlexaWebService::Response.new

      if @echo_request.launch_request
        response.spoken_response = "Hello user"
        response.end_session = true
      end

      response.without_card.to_json

      # the following is for the alexa_skills_ruby gem
      # hdrs = { 'Signature' => request.env['HTTP_SIGNATURE'], 'SignatureCertChainUrl' => request.env['HTTP_SIGNATURECERTCHAINURL'] }
      # handler.handle(request.body.read, hdrs)
      # logger.info handler.response
      # render handler.response.to_json
      # handler renders as follows
      # handler.response.to_json

      # {"shouldEndSession":true,
      #   "outputSpeech":{
      #     "type":"PlainText",
      #     "text":"Start New Deck Text"},
      #   "card":{
      #     "type":"Simple",
      #     "title":"title",
      #     "content":"content"},
      #   "reprompt":{
      #     "outputSpeech":{
      #       "type":"PlainText",
      #       "text":"Start New Deck Reprompt Text"}
      #       }
      #     }

      # whereas the following code is valid for alexa
      # resp = {
      #         "version": "1.0",
      #         "response": {
      #           "shouldEndSession": true,
      #           "outputSpeech": {
      #             "type": "PlainText",
      #             "text": "Hello Alexa!"
      #           },
      #           "card": {
      #             "type": "Simple",
      #             "title": "Greeter",
      #             "content": "Hello Alexa!"
      #           }
      #         }
      #       }
      # render :json => resp

      # the request is being read properly via request.body.read

    rescue AlexaSkillsRuby::InvalidApplicationId => e
      logger.error e.to_s
      403
    end
  end

  def show
    render "Hello, this is Alexa Flashcards Ruby!"
  end
end
