require_relative '../spec_helper'
include Clerq::Repositories

describe TextRepository do

  let(:filename) { 'spec.md.tt' }
  let(:filebody) { 'tttemplate' }

  describe '#text' do
    it 'must return file content for file' do
      Sandbox.() do
        repo = TextRepository.new(pattern: ['*.md.tt', '*.md.erb'])
        repo.inside { File.write(filename, filebody) }
        _(repo.text(filename)).must_equal filebody
      end
    end

    it 'must return file content by name without extension' do
      Sandbox.() do
        repo = TextRepository.new(pattern: ['*.md.tt', '*.md.erb'])
        repo.inside { File.write(filename, filebody) }
        _(repo.text(filename.split(".").first)).must_equal filebody
      end
    end

    it 'must raise StandardError when file not found' do
      Sandbox.() do
        repo = TextRepository.new(pattern: ['*.md.tt', '*.md.erb'])
        _(proc{repo.text('file.does.not.exist')}).must_raise StandardError
      end
    end
  end

  describe '#find' do

    it 'must find in nested folders' do
      Sandbox.() do
        repo = TextRepository.new(pattern: ['*.md.tt', '*.md.erb'])
        repo.inside do
          Dir.mkdir('spec')
          Dir.chdir('spec') { File.write(filename, filebody) }
        end
        _(repo.find(filename)).must_equal "spec/#{filename}"
        _(repo.find(filename.split('.').first)).must_equal "spec/#{filename}"
      end
    end

    describe 'when name matches file' do
      it 'must return file equal to name' do
        Sandbox.() do
          repo = TextRepository.new(pattern: ['*.md.tt', '*.md.erb'])
          repo.inside { File.write(filename, filebody) }
          repo.inside { _(repo.find(filename)).must_equal filename }
          _(repo.find(filename)).must_equal filename
        end
      end
    end

    describe 'when name does not match file' do
      it 'must try by joining patterns' do
        Sandbox.() do
          repo = TextRepository.new(pattern: ['*.md.tt', '*.md.erb'])
          repo.inside { File.write(filename, filebody) }
          para = filename.split('.').first
          repo.inside { _(repo.find(para)).must_equal filename }
          _(repo.find(para)).must_equal filename
        end
      end
    end

    describe 'when file not found' do
      it 'must return empty string' do
        Sandbox.() do
          repo = TextRepository.new(pattern: ['*.md.tt', '*.md.erb'])
          _(repo.find('file.that.not.exits')).must_equal ''
        end
      end
    end
  end

end
