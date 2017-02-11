class Flashcards
  attr_accessor :cards, :answers

  def initialize
    @cards = [
      { question: "To create a second name for the variable or method.",
        answers: ["alias", "begin", "else", "elsif"] },
      { question: "A command that appends two or more objects together.",
        answers: ["break", "do", "and", "ensure"] },
      { question: "Designates code that must be run unconditionally at the beginning of the program before any other.",
        answers: ["if", "BEGIN", "in", "case"] },
      { question: "Gives an unconditional termination to a code block, and is usually placed with an argument.",
        answers: ["elsif", "break", "class", "false"] },
      { question: "starts a case statement; this block of code will output a result and end when it's terms are fulfilled, which are defined with when or else.",
        answers: ["case", "begin", "class", "end"] },
      { question: "Opens a class definition block, which can later be reopened and added to with variables and even functions.",
        answers: ["ensure", "and", "alias", "class"] },
      { question: "Used to define a function.",
        answers: ["false", "for", "def", "if"] },
      { question: "A boolean logic function that asks whether or not a targeted expression refers to anything recognizable in Ruby; i.e. literal object, local variable that has been initialized, method name visible from the current scope, etc.",
        answers: ["for", "next", "defined?", "false"] },
      { question: "Paired with end, this can delimit a code block, much like curly braces; however, curly braces retain higher precedence.",
        answers: ["do", "retry", "rescue", "while"] },
      { question: "Gives an 'otherwise' within a function, if-statement, or for-loop, i.e. if cats = cute, puts 'Yay!' else puts 'Oh, a cat.'",
        answers: ["alias", "end", "else", "elsif"] },
      { question: "Much like else, but has a higher precedence, and is usually paired with terms.",
        answers: ["ensure", "class", "def", "elsif"] },
      { question: "Designates, via code block, code to be executed just prior to program termination.",
        answers: ["or", "END", "while", "undef"] },
      { question: "Marks the end of a while, until, begin, if, def, class, or other keyword-based, block-based construct.",
        answers: ["super", "end", "self", "false"] },
      { question: "Marks the final, optional clause of a begin/end block, generally in cases where the block also contains a rescue clause. The code in this term's clause is guaranteed to be executed, whether control flows to a rescue block or not.",
        answers: ["if", "ensure", "for", "module"] },
      { question: "denotes a special object, the sole instance of FalseClass. false and nil are the only objects that evaluate to Boolean falsehood in Ruby (informally, that cause an if condition to fail.)",
        answers: ["ensure", "until", "false", "unless"] },
      { question: "A loop constructor; used in for-loops.",
        answers: ["for", "super", "while", "module"] },
      { question: "Ruby's basic conditional statement constructor.",
        answers: ["return", "rescue", "if", "while"] },
      { question: "Used with for, helps define a for-loop.",
        answers: ["if", "end", "else", "in"] },
      { question: "Opens a library, or module, within a Ruby Stream.",
        answers: ["module", "retry", "for", "class"] },
      { question: "Bumps an iterator, or a while or until block, to the next iteration, unconditionally and without executing whatever may remain of the block.",
        answers: ["true", "retry", "next", "self"] },
      { question: "A special 'non-object'; it is, in fact, an object (the sole instance of NilClass), but connotes absence and indeterminacy. nil and false are the only two objects in Ruby that have Boolean falsehood (informally, that cause an if condition to fail).",
        answers: ["nil", "module", "retry", "undef"] },
      { question: "Boolean negation. i.e. not true # false, not 10 # false, not false # true.",
        answers: ["rescue", "not", "self", "unless"] },
      { question: "Boolean or. Differs from double pipe in that or has lower precedence.",
        answers: ["super", "until", "while", "or"] },
      { question: "Causes unconditional re-execution of a code block, with the same parameter bindings as the current execution.",
        answers: ["super", "for", "if", "redo"] },
      { question: "Designates an exception-handling clause that can occur either inside a begin<code>/<code>end block, inside a method definition (which implies begin), or in modifier position (at the end of a statement).",
        answers: ["rescue", "return", "then", "true"] },
      { question: "Inside a rescue clause, causes Ruby to return to the top of the enclosing code (the begin keyword, or top of method or block) and try executing the code again.",
        answers: ["for", "retry", "in", "next"] },
      { question: "Inside a method definition, executes the ensure clause, if present, and then returns control to the context of the method call. Takes an optional argument (defaulting to nil), which serves as the return value of the method. Multiple values in argument position will be returned in an array.",
        answers: ["retry", "true", "return", "while"] },
      { question: "The 'current object' and the default receiver of messages (method calls) for which no explicit receiver is specified. Which object plays the role of self depends on the context.",
        answers: ["while", "then", "super", "self"] },
      { question: "Called from a method, searches along the method lookup path (the classes and modules available to the current object) for the next method of the same name as the one being executed. Such method, if present, may be defined in the superclass of the object's class, but may also be defined in the superclass's superclass or any class on the upward path, as well as any module mixed in to any of those classes.",
        answers: ["true", "super", "until", "when"] },
      { question: "Optional component of conditional statements (if, unless, when). Never mandatory, but allows for one-line conditionals without semi-colons.",
        answers: ["then", "while", "until", "retry"] },
      { question: "The sole instance of the special class TrueClass. true encapsulates Boolean truth; however, <emph>all</emph> objects in Ruby are true in the Boolean sense (informally, they cause an if test to succeed), with the exceptions of false and nil.",
        answers: ["break", "ensure", "module", "true"] },
      { question: "Undefines a given method, for the class or module in which it's called. If the method is defined higher up in the lookup path (such as by a superclass), it can still be called by instances classes higher up.",
        answers: ["when", "undef", "yield", "rescue"] },
      { question: "The negative equivalent of if. i.e. unless y.score > 10 puts 'Sorry; you needed 10 points to win.' end.",
        answers: ["yield", "end", "unless", "alias"] },
      { question: "The inverse of while: executes code until a given condition is true, i.e., while it is not true. The semantics are the same as those of while.",
        answers: ["until", "module", "retry", "case"] },
      { question: "Same as case.",
        answers: ["return", "self", "super", "when"] },
      { question: "Takes a condition argument, and executes the code that follows (up to a matching end delimiter) while the condition is true.",
        answers: ["for", "redo", "while", "yield"] },
      { question: "Called from inside a method body, yields control to the code block (if any) supplied as part of the method call. If no code block has been supplied, calling yield raises an exception.",
        answers: ["yield", "end", "class", "undef"] }
      ]

    @answers = [1, 3, 2, 2, 1, 4, 3, 3, 1, 3, 4, 2, 2, 2, 3, 1, 3, 4, 1,
      3, 1, 2, 4, 4, 1, 2, 3, 4, 2, 1, 4, 2, 3, 1, 4, 3, 1]
    # index_with_answers = [01, 13, 22, 32, 41, 54, 63, 73, 81, 93, 104, 112, 122, 132, 143, 151, 163, 174, 181,
    #   193, 201, 212, 224, 234, 241, 252, 263, 274, 282, 291, 304, 312, 323, 331, 344, 353, 361]
  end

  def getSample
    sample = Array(0..36).sample
    answerIndex = @answers[sample]
    question = @cards[sample][:question]
    answers = @cards[sample][:answers]
    answer = @cards[sample][:answers][answerIndex]
    return sample, answerIndex, question, answers, answer
  end
end
