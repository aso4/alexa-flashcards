#require 'net/http'
#require 'alexa_skills_ruby'

class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

    handler = CustomHandler.new(application_id: 'amzn1.ask.skill.8fd7504e-1979-4837-81cc-82db38a26f02', logger: logger)

    begin
      hdrs = { 'Signature' => request.env['HTTP_SIGNATURE'], 'SignatureCertChainUrl' => request.env['HTTP_SIGNATURECERTCHAINURL'] }
      handler.handle(request.body.read, hdrs)
      logger.info "handler response is as follows:"
      logger.info handler.response.to_json
      logger.info "the request body is as follows:"
      logger.info request.body.read
    rescue AlexaSkillsRuby::InvalidApplicationId => e
      logger.error e.to_s
      403
    end

    # the following code should be rendered in json
    resp = {
            "version": "1.0",
            "response": {
              "shouldEndSession": true,
              "outputSpeech": {
                "type": "PlainText",
                "text": "Hello Alexa!"
              },
              "card": {
                "type": "Simple",
                "title": "Greeter",
                "content": "Hello Alexa!"
              }
            }
          }
    render :json => resp
#:json => handler.response

  end

  def show
    render "Hello, this is Alexa Flashcards Ruby!"
  end
  #
  # def haze_intent intent
  #   result = Net::HTTP.get(URI.parse('http://sghaze.herokuapp.com/'))
  #
  #   json = JSON.parse(result)
  #
  #   values = []
  #   values << json["North"].to_i
  #   values << json["South"].to_i
  #   values << json["East"].to_i
  #   values << json["West"].to_i
  #
  #   average = values.sum / values.size.to_f
  #
  #   description = "hazardous"
  #   if average <= 50
  #     description = "good"
  #   elsif average <= 100
  #     description = "moderate"
  #   elsif average <= 200
  #     description = "unhealthy"
  #   elsif average <= 300
  #     description = "very unhealthy"
  #   end
  #
  #   @message = "The PSI is now 300"
  # end
  #
  # def pregnancy_intent intent
  #   date = Date.strptime("14/12/2015", "%d/%m/%Y")
  #   week = 40 - (date.cweek - Date.today.cweek)
  #   @message = "Baby is now #{week} weeks."
  # end
  #
  #
  # def lottery_review_intent intent
  #   result = Net::HTTP.get(URI.parse('http://gsgresult.appspot.com/api/4d/?afterdrawnum=3800'))
  #
  #   json = JSON.parse(result)
  #
  #   slots = intent["slots"]
  #   slots.each do |key, value|
  #     puts "key:#{key}"
  #     if key != "date"
  #       next
  #     end
  #
  #     date = Date.strptime(value["value"], "%Y-%m-%d")
  #
  #     date_string = date.strftime("%b %-d, %Y")
  #
  #     result = {}
  #
  #     json.each do |draw|
  #       draw_date = draw["drawDate"]
  #
  #       if draw_date.starts_with?(date_string)
  #         result = draw
  #         break
  #       end
  #     end
  #
  #     @message = "First Prize #{humanize(result["wn1"])};
  #     Second Prize #{humanize(result["wn2"])};
  #     Third Prize #{humanize(result["wn3"])}"
  #   end
  #
  #   # puts json
  # end
  #
  # def lights_intent intent
  #   slots = intent["slots"]
  #
  #   colour = ""
  #   on_off = ""
  #   slots.each do |key, value|
  #     if key == "switch"
  #       on_off = value["value"]
  #     elsif key == "colour"
  #       colour = value["value"]
  #     end
  #   end
  #
  #   if colour == "red"
  #     if on_off == "on"
  #       @@lights |= 0b001
  #     else
  #       @@lights &= 0b110
  #     end
  #   elsif colour == "green"
  #     if on_off == "on"
  #       @@lights |= 0b010
  #     else
  #       @@lights &= 0b101
  #     end
  #   elsif colour == "blue"
  #     if on_off == "on"
  #       @@lights |= 0b100
  #     else
  #       @@lights &= 0b011
  #     end
  #   end
  #
  #   @message = "Please check the lights! #{@@lights}"
  # end
  #
  # def humanize number
  #   string = []
  #   string << (number/1000).to_words
  #   string << ((number/100) %10).to_words
  #   string << ((number/10) %10).to_words
  #   string << (number%10).to_words
  #
  #   string.join(", ")
  # end
  #
  # def bank_account_intent intent
  #
  # end

end

#   def dd
#     handler = Alexa.new(application_id: 'amzn1.ask.skill.55efad5c-72fc-45bc-aca5-9e713f352e81', logger: Rails.logger)
#     begin
#       Rails.logger.info request.body.read
#       handler.handle(request.body.read)
#       # render json: {bar:'zzz'}
#     rescue AlexaSkillsRuby::InvalidApplicationId => e
#       logger.error e.to_s
#       403
#     end
#   end
#
# end
