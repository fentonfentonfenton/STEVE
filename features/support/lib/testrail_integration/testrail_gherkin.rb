# frozen_string_literal: false

module Testrail
  def scenario_gherkin
    steps = @scenario.all_source.map do |step|
      build_text_from_(step) if gherkin_step?(step)
    end
    steps.compact.join("\n")
  end

  def build_text_from_(step)
    if step.methods.include? :keyword
      gherkin_regex = /(Given|When|Then|And|But)/

      gherkin = "#{step.keyword}#{step.text}" if gherkin_regex.match? step.keyword
      gherkin << formatted_multiline_argument_from(step) if multiline_argument?(step)
    end
    gherkin
  end

  def multiline_argument?(step)
    step.multiline_arg.respond_to?(:to_str)
  end

  def formatted_multiline_argument_from(step)
    "\n\n#{step.multiline_arg}\n\n"
  end

  def gherkin_step?(step)
    (step.methods.include? :keyword) || (step.methods.include? :multiline_arg)
  end
end
