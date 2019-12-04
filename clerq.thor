# encoding: UTF-8

require 'thor'

class ClerqSrc < Thor
  include Thor::Actions
  namespace 'clerq:src'.to_sym

  desc 'docs', 'Prepare docs'
  def docs
    # to wrap all '{{}}' of README.md with `{% raw %} <> {% endraw %}
    text = File.read(SOURCE)
    SUBS.each{|patt, subs|
      text.scan(patt).uniq.each{|e| text.gsub!(e, subs.call(e))}
    }
    File.write(TARGET, text)
    say "'#{TARGET}' created!"
  end

  SOURCE = 'README.md'
  TARGET = 'docs/README.md'
  REX1, REX2 = /`{{[\s\S]*?}}`/, /```markdown[\s\S]*?```/
  SUBS = {}.tap do |curly|
    curly[REX1] = lambda {|e| "{% raw %}#{e}{% endraw %}" }
    curly[REX2] = lambda {|e| "{% raw %}\n#{e}\n{% endraw %}" }
  end.freeze

end
