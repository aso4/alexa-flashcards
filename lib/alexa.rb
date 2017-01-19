class Alexa < AlexaSkillsRuby::Handler

  on_launch do
    response.set_output_speech("What's up dog?")
  end

  on_intent("DailyDataIntent") do
    slots = request.intent.slots
    response.set_output_speech_text("Something will happen")
    #response.set_simple_card("title", "content")
    logger.info 'DailyDataIntent processed'
  end

  on_intent("Intent2") do
    slots = request.intent.slots
    response.set_output_speech_text("Something will happen")
    #response.set_simple_card("title", "content")
    logger.info 'DailyDataIntent processed'
  end

  on_intent("Intent3") do
    slots = request.intent.slots
    response.set_output_speech_text("Something will happen #{slots['attraction']}")
    #response.set_simple_card("title", "content")
    logger.info 'DailyDataIntent processed'
  end

end
