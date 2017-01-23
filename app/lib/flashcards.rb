class Flashcards
  attr_accessor :cards, :answers

  @cards = [
    { question: "To create a second name for the variable or method.",
      answers: ["alias", "two", "three", "four"] },
    { question: "A command that appends two or more objects together.",
      answers: "and" },
    { question: "Designates code that must be run unconditionally at the beginning of the program before any other.",
      answers: "BEGIN" },
    ]

  @answers = [1, 3, 4, 2, 3]

  Delimits a "begin" block of code, which can allow the use of while and until in modifier position with multi-line statements.
  begin

  Gives an unconditional termination to a code block, and is usually placed with an argument.
  break

  starts a case statement; this block of code will output a result and end when it's terms are fulfilled, which are defined with when or else.
  case

  Opens a class definition block, which can later be reopened and added to with variables and even functions.
  class

  Used to define a function.
  def

  A boolean logic function that asks whether or not a targeted expression refers to anything recognizable in Ruby; i.e. literal object, local variable that has been initialized, method name visible from the current scope, etc.
  defined?

  Paired with end, this can delimit a code block, much like curly braces; however, curly braces retain higher precedence.
  do

  Gives an "otherwise" within a function, if-statement, or for-loop, i.e. if cats = cute, puts "Yay!" else puts "Oh, a cat."
  else

  Much like else, but has a higher precedence, and is usually paired with terms.
  elsif

  Designates, via code block, code to be executed just prior to program termination.
  END

  Marks the end of a while, until, begin, if, def, class, or other keyword-based, block-based construct.
  end

  Marks the final, optional clause of a begin/end block, generally in cases where the block also contains a rescue clause. The code in this term's clause is guaranteed to be executed, whether control flows to a rescue block or not.
  ensure

  denotes a special object, the sole instance of FalseClass. false and nil are the only objects that evaluate to Boolean falsehood in Ruby (informally, that cause an if condition to fail.)
  false

  A loop constructor; used in for-loops.
  for

  Ruby's basic conditional statement constructor.
  if

  Used with for, helps define a for-loop.
  in

  Opens a library, or module, within a Ruby Stream.
  module

  Bumps an iterator, or a while or until block, to the next iteration, unconditionally and without executing whatever may remain of the block.
  next

  A special "non-object"; it is, in fact, an object (the sole instance of NilClass), but connotes absence and indeterminacy. nil and false are the only two objects in Ruby that have Boolean falsehood (informally, that cause an if condition to fail).
  nil

  Boolean negation. i.e. not true # false, not 10 # false, not false # true.
  not

  Boolean or. Differs from || in that or has lower precedence.
  or

  Causes unconditional re-execution of a code block, with the same parameter bindings as the current execution.
  redo

  Designates an exception-handling clause that can occur either inside a begin<code>/<code>end block, inside a method definition (which implies begin), or in modifier position (at the end of a statement).
  rescue

  Inside a rescue clause, causes Ruby to return to the top of the enclosing code (the begin keyword, or top of method or block) and try executing the code again.
  retry

  Inside a method definition, executes the ensure clause, if present, and then returns control to the context of the method call. Takes an optional argument (defaulting to nil), which serves as the return value of the method. Multiple values in argument position will be returned in an array.
  return

  The "current object" and the default receiver of messages (method calls) for which no explicit receiver is specified. Which object plays the role of self depends on the context.
  self

  Called from a method, searches along the method lookup path (the classes and modules available to the current object) for the next method of the same name as the one being executed. Such method, if present, may be defined in the superclass of the object's class, but may also be defined in the superclass's superclass or any class on the upward path, as well as any module mixed in to any of those classes.
  super

  Optional component of conditional statements (if, unless, when). Never mandatory, but allows for one-line conditionals without semi-colons.
  then

  The sole instance of the special class TrueClass. true encapsulates Boolean truth; however, <emph>all</emph> objects in Ruby are true in the Boolean sense (informally, they cause an if test to succeed), with the exceptions of false and nil.
  true

  Undefines a given method, for the class or module in which it's called. If the method is defined higher up in the lookup path (such as by a superclass), it can still be called by instances classes higher up.
  undef

  The negative equivalent of if. i.e. unless y.score > 10 puts "Sorry; you needed 10 points to win." end.
  unless

  The inverse of while: executes code until a given condition is true, i.e., while it is not true. The semantics are the same as those of while.
  until

  Same as case.
  when

  Takes a condition argument, and executes the code that follows (up to a matching end delimiter) while the condition is true.
  while

  Called from inside a method body, yields control to the code block (if any) supplied as part of the method call. If no code block has been supplied, calling yield raises an exception.
  yield }
