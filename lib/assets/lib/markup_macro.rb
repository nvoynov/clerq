# encoding: UTF-8

# Macro that can be used in MarkupNode
#
# Usage:
#   node = MarkupNode(Clerq::Entities::Node.new(
#     id: 'id', body: Some text that contains {{@@macro}}")
#   )
#   macro = Macro.new
#   macro.(node.body, node) # "Some text that contains [processed macro]"
class MarkupMacro
  attr_reader :title, :regex
  # TODO: find more situable name
  # Process macro that must be implemented in subclasses
  # @param macro [String] macrotext
  # @param node [Node] the context in which the macro is processed
  # @return [String] a text processed by macro
  def process(macro, node)
  end
end

# Just skip macro and all the text inside it
class SkipMacro < MarkupMacro
  def initialize
    @title = "Skip"
    @regex = /{{@@skip[\s\S]*?}}/
  end

  def process(macro, node = nil)
    ""
  end
end

# Evaluates ruby code placed inside the macro
class EvalMacro < MarkupMacro
  def initialize
    @title = "Eval"
    @regex = /{{@@eval[\s\S]*?}}/
    @extra = /{{@@eval([\s\S]*?)}}/
  end

  def process(macro, node)
    body = @extra.match(macro)[1]
    eval(body, binding)
  end
end

# Builds a list of Node#items where items linked to appropriate headers
class ListMacro < MarkupMacro
  def initialize
    @title = "List"
    @regex = /{{@@list}}/
  end

  def process(macro, node)
    node.items.inject([]) do |ary, n|
      ary << "* [#{n.title}](##{node.url(n.id)})"
    end.join("\n")
  end
end

# Builds a tree of Node#items where items linked to appropriate headers
class TreeMacro < MarkupMacro
  def initialize
    @title = "Tree"
    @regex = /{{@@tree}}/
  end

  def process(macro, node)
    this_level = node.nesting_level + 1
    node.to_a.drop(1).inject([]) do |ary, n|
      lead_spaces = '   ' * (n.nesting_level - this_level)
      ary << "#{lead_spaces}* [#{n.title}](##{node.url(n.id)})"
    end.join("\n")
  end

end
