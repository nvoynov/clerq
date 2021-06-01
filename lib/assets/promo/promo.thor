require 'clerq'
require 'thor'

class Promo < Thor
  include Thor::Actions
  namespace :promo

  desc "publish", "Publish document"
  def publish
    doc = Clerq.settings.document
    tmp = '.publish.md'
    `clerq build -o #{tmp}`
    Dir.chdir(Clerq.settings.bin) do
      `pandoc -s --toc #{tmp} -o "#{doc}.docx"`
      File.delete(tmp)
    end
  end

  desc "toc", "Print TOC"
  def toc
    node = Clerq::Interactors::JoinNodes.()
    puts "% #{node.title}"
    node.to_a.drop(1).each do |n|
      puts  "#{'  ' * (n.nesting_level - 1)}[#{n.id}] #{n.title}"
    end
  end

  desc "mm", "Create meeting minutes"
  def mm
    minutes = "meeting minutes #{Time.new.strftime('%Y-%m-%d')}.md"
    content = "% #{minutes.capitalize}\n\n" + MINUTES_TEMPLATE
    Dir.mkdir('mm') unless Dir.exist?('mm')
    File.write("mm/#{minutes}", content)
    say "'mm/#{minutes}' created!"
  end

  MINUTES_TEMPLATE = <<~EOF
    # Attendants

    1.
    2.
    3.

    # Questions

    1.
    2.
    3.

    # Resolutions

    1.
    2.
    3.
  EOF


end
