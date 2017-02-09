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

    # If the request body has been read, you need to rewind it.
    request.body.rewind
    AlexaWebService::AlexaVerify.new(request.env, request.body.read)

    @response = AlexaResponse.new
    @response.spoken_response = "Hello user"
    @response.end_session = true
    logger.info "response is: #{@response.with_card.to_json}"

    render json: @response.with_card

  end

  def show
    render "Hello, this is Alexa Flashcards Ruby!"
  end
end
