require 'delegate'
require_relative 'markup_macro'

# MarkupNode is an wrapper introduced to simplify
#   producing Pandoc markdown output.
#   It's a delegator to the Node class
class MarkupNode < SimpleDelegator

  # register available macros
  @@macros = Array.new.tap do |ary|
    ary << SkipMacro.new
    ary << ListMacro.new
    ary << TreeMacro.new
    ary << EvalMacro.new
    ary.freeze
  end

  def markup
    [title, meta, body].select{|part| !part.empty?}.join("\n\n")
  end

  # @return [String] output text of node.title
  def title
    s = super
    s = ".#{id.split(/\./).last}" if s.empty?
    "#{'#' * nesting_level} #{s} {##{url(id)}}"
  end

  # @return [String] output text of node.meta
  def meta
    return '' if nesting_level == 0
    return '' if super[:skip_meta]

    hsh = {id: id}.merge(super)
    hsh.delete(:order_index)
    hsh.delete(:filename)
    hsh.delete(:parent)
    [].tap{|ary|
      ary << "Attribute | Value"
      ary << "--------- | -----"
      hsh.each{|k,v| ary << "#{k} | #{v}"}
    }.join("\n")
  end

  # @return [String] output text for node.body
  def body
    String.new(super).tap do |txt|
      process_links!(txt)
      process_macro!(txt)
      txt.gsub!(/^$\n{2,}/, "\n")
    end
  end

  # @return [String] output text for link [[node.id]]
  def link(ref)
    node = root.find{|n| n.id == ref}
    return "[#{ref}](#unknown)" unless node
    "[#{node.title}](##{url(ref)})"
  end

  # @return [String] url for node.id
  def url(id)
    r = id.start_with?(/[[:digit:]]/) ? "p#{id}" : id
    r.downcase
     .gsub(/[^A-Za-z0-9]{1,}/, '-')
     .gsub(/^-/, '')
     .gsub(/-$/, '')
  end

  private

  # process links and replace macros by markup output
  # @param source [String] input string
  # @return [String] markup output
  def process_links!(source)
    links.each{ |l| source.gsub!("[[#{l}]]", link(l)) }
  end

  def process_macro!(source)
    @@macros.each do |macro|
      source.scan(macro.regex).each do |i|
        source.gsub!(i, macro.process(i, self))
      end
    end
  end
end
