require_relative '../spec_helper'
include Clerq::Repositories

describe FileRepository do

  # brings protected methods accessible
  class FileSpecRepo < FileRepository
    def glob(pattern = '')
      super(pattern)
    end

    def read(filename)
      super(filename)
    end

    def write(filename, content)
      super(filename, content)
    end
  end

  describe '#read' do
    it 'must return file content' do
      Sandbox.() do
        repo = FileSpecRepo.new
        repo.inside { File.write('spec.md', '# Spec')}
        _(repo.read('spec.md')).must_equal '# Spec'
      end
    end

    it 'must raise StandardError when file not found' do
      Sandbox.() do
        repo = FileSpecRepo.new
        _(proc { repo.read('file.does.not.exist') }).must_raise StandardError
      end
    end
  end

  describe '#write' do
    it 'must write file' do
      Sandbox.() do
        repo = FileSpecRepo.new
        repo.write('spec.md', '# Spec')
        _(repo.read('spec.md')).must_equal '# Spec'
      end
    end

    it 'must raise StandardError when file exists' do
      Sandbox.() do
        repo = FileSpecRepo.new
        repo.write('spec.md', '# Spec')
        _(proc { repo.write('spec.md', '# Spec') }).must_raise StandardError
      end
    end
  end

  describe '#glob' do
    it 'must return all files according to pattern' do
      Sandbox.() do
        repo = FileSpecRepo.new
        repo.write('first.md', '')
        repo.write('first.rb', '')
        repo.inside do
          Dir.mkdir('spec')
          Dir.chdir('spec') do
            File.write('nested.md', '')
            File.write('nested.rb', '')
          end
        end
        _(repo.glob).must_equal [
          'first.md', 'first.rb', 'spec/nested.md', 'spec/nested.rb']
        _(repo.glob('*.md')).must_equal ['first.md', 'spec/nested.md']
        _(repo.glob('*.rb')).must_equal ['first.rb', 'spec/nested.rb']
      end
    end
  end

end
