require 'clerq'
require 'erb'
include Clerq::Entities
include Clerq::Services

# Creates clerq repository sources in current work directory
# Warning! Change work dierectory before calling for the serice
# Usage
#   node = Clerq.node_repository.assembly
#   Dir.chdir(Clerq.src) { ColonizeRepo.(node) }
class ColonizeRepo < Service
  private_class_method :new

  def call
    write(@node)
  end

  # TODO callback? and calback for ReadNode.()?
  def write(node)
    dir = folder(node)
    src = source(node)
    txt = text(node)
    unless dir.empty? || Dir.exist?(dir)
      Dir.mkdir(dir)
      @on_create_dir.call(dir) if @on_create_dir
    end
    File.write(src, txt)
    @on_create_file.call(src) if @on_create_file
    node.items.reject{|n| n.items.empty?}.each{|n| write(n)}
  end

  # @param node [Node] the node for colonization
  # @param on_create_file [Block(arg)] on create new file callback
  # @param on_create_dir [Block(arg)] on create new directory callback
  def initialize(node, on_create_dir = nil, on_create_file = nil)
    @node = node
    @on_create_dir = on_create_dir
    @on_create_file = on_create_file
  end

  def source(node)
    fld = folder(node)
    src = filename(node)
    fld.empty? ? src : File.join(fld, src)
  end

  def folder(node)
    dir = ''
    n = node
    while n != @node.root && n.parent != @node.root
      dir = File.join("#{n.parent.id} #{n.parent.title}", dir)
      n = n.parent
    end
    dir
  end

  def filename(node)
    "#{node.id} #{node.title}.md"
  end

  # TODO replace to services
  def text(node)
    RenderErb.(erb: TEMPLATE, object: node)
  end

  TEMPLATE = <<~EOF
    # <%= @object.title %>
    {{id: <%= @object.id %><%= ", parent: " + @object.parent.id if @object.parent %>, order_index: <%= @object.items.map(&:id).join(' ') %>}}

    <%= @object.body %>

    <% for n in @object.items -%>
    <%   next unless n.items.empty? -%>
    ## <%= n.title %>
    {{id: <%= n.id %>}}

    <%= n.body %>

    <% end %>
  EOF

end
