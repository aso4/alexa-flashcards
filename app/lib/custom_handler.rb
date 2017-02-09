require 'alexa_skills_ruby'

class CustomHandler < AlexaSkillsRuby::Handler

  on_launch do
    response.set_output_speech_text("What's up dog?")
    logger.info 'launch request processed'
  end

  on_intent("AMAZON.StartOverIntent") do
    slots = request.intent.slots
    response.set_output_speech_text("Start New Deck Text")
    #response.set_output_speech_ssml("<speak><p>Horoscope Text</p><p>More Horoscope text</p></speak>")
    response.set_reprompt_speech_text("Start New Deck Reprompt Text")
    #response.set_reprompt_speech_ssml("<speak>Reprompt Horoscope Text</speak>")
    response.set_simple_card("title", "content")
    logger.info 'StartOverIntent processed'
    logger.info response.class
  end

  on_intent("DailyDataIntent") do
    slots = request.intent.slots
    response.set_output_speech_text("Something will happen")
    #response.set_simple_card("title", "content")
    logger.info 'DailyDataIntent processed'
  end

  # on_intent("AMAZON.StartOverIntent") do
  #   response.set_output_speech_text("What's up dog?")
  # end

  on_intent("AnswerIntent") do
    @flashcard_answers = Flashcards.new().answers
    @flashcard_answers.sample
  end

  on_intent("Intent3") do
    slots = request.intent.slots
    response.set_output_speech_text("Something will happen #{slots['attraction']}")
    #response.set_simple_card("title", "content")
    logger.info 'DailyDataIntent processed'
  end

end
