class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def dd
    handler = Alexa.new(application_id: 'amzn1.ask.skill.8606013b-8292-4e3f-9628-fa472615e78a', logger: Rails.logger)
    begin
      Rails.logger.info request.body.read
      handler.handle(request.body.read)
      # render json: {bar:'zzz'}
    rescue AlexaSkillsRuby::InvalidApplicationId => e
      logger.error e.to_s
      403
    end
  end
end
