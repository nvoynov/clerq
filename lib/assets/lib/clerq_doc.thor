require 'clerq'
require 'thor'
require 'tmpdir'
require_relative 'lib/colonize_repo'
include Clerq::Repositories
include Clerq::Entities
include Clerq::Services

# This thor file sample was created with purpose to show some examples
# of using Pandoc for clerq reposiory publishing and even import souce
# documents into a clerq repository ... `thor clerq:doc:grab`, `thor clerq:doc:publish`
class ClerqDoc < Thor
  include Thor::Actions
  namespace 'clerq:doc'.to_sym

  no_commands {
    def eqid!(node)
      counter = {}
      node.to_a.drop(1).each do |n|
        index = counter[n.parent] || 1
        counter[n.parent] = index + 1
        id = index.to_s.rjust(2, '0')
        id = '.' + id unless n.parent == node
        n.id = id
      end
    end
  }

  # Why does one need to grab the document?
  #   it started in MS Word but the author decieded to pкoceed in Clerq
  #   it is the source for the clerq project, SRS based on Vision?
  #   something else?
  # TODO provide -q/--query QUERY_STRING parameter
  # TODO how about importing images?
  desc 'grab FILENAME', 'Grab document and populate the clerq repository'
  def grab(filename)
    mdown = File.join(Dir.tmpdir, 'clerq.grab.md')
    optns = [].tap{|o|
      o << '--wrap=none'
      o << '--atx-headers'
      o << "#{filename}"
      o << "-o #{mdown}"
    }.join(' ')

    `pandoc #{optns}`

    on_error_callback = lambda {|err| puts err}
    puts "Reading '#{mdown}'..."

    # TODO handle query parameter
    arry = ReadNode.(mdown, on_error_callback)
    node = Node.new(id: '00', title: File.basename(mdown, '.md'))
    arry.each{|n| node << n}
    eqid!(node)

    puts "Colonizing this repository..."
    dir_counter = 0
    src_counter = 0
    on_create_dir = lambda {|dir| puts "Created '#{dir}' directory"; dir_counter += 1 }
    on_create_src = lambda {|src| puts "Created '#{src}' file"; src_counter += 1 }

    Dir.chdir(Clerq.src) { ColonizeRepo.(node, on_create_dir, on_create_src) }

    msg = [].tap do |memo|
      memo << "#{dir_counter} #{dir_counter == 1 ? 'directory' : 'directories'}" if dir_counter > 0
      memo << "#{src_counter} #{src_counter == 1 ? 'file' : 'files'}" if src_counter > 0
    end.join(' and ')

    say "#{node.to_a.size} nodes from '#{filename}' imported to the repositroy. #{msg} created in the repository."
  end

  desc 'publish', 'Publishing final deliverables'
  def publish
    invoke :docx
    invoke :html
  end

  desc 'html', 'Publish final deliverable in Html'
  def html
    source = File.join(Clerq.bin, Clerq.document + ".md")
    target = File.join(Clerq.bin, Clerq.document + ".html")
    optns = [].tap{|o|
      o << '-s --toc --toc-depth 3'
      o << "--resource-path #{Clerq.bin}"
      o << "\"#{source}\""
      o << "-o \"#{target}\""
    }.join(" ")

    `clerq build -t pandoc.md.erb`
    `pandoc #{optns}`
    say "\"#{target}\" created!"
  end

  desc 'docx', 'Publish final deliverable in Docx'
  def docx
    source = File.join(Clerq.bin, Clerq.document + ".md")
    target = File.join(Clerq.bin, Clerq.document + ".docx")
    sample = File.join(Clerq.bin, 'custom-reference.docx')

    unless File.exist?(sample)
      # produce a custom reference.docx
      `pandoc -o #{sample} --print-default-data-file reference.docx`
    end

    optns = [].tap{|o|
      o << '-s --toc --toc-depth 3'
      o << '--from markdown+table_captions+implicit_figures'
      o << "--reference-doc #{sample}"
      o << "--resource-path #{Clerq.bin}"
      o << "\"#{source}\""
      o << "-o \"#{target}\""
    }.join(" ")

    `clerq build -t pandoc.md.erb`
    `pandoc #{optns}`
    say "\"#{target}\" created!"
  end

end
