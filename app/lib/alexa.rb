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

  on_intent("StartOverIntent") do
    response.set_output_speech("What's up dog?")
  end

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

 # 1. ngrok configured to trigger launch intent
 # 2. utterances, how slots are configured
 # 3. etc.
