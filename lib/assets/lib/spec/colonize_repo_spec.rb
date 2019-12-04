require 'clerq'
require 'erb'
require 'minitest/autorun'
require_relative 'colonize_repo'
include Clerq::Entities
include Clerq::Services

describe ColonizeRepo do
  class FakeWriter < ColonizeRepo
    public_class_method :new
    attr_reader :node
  end

  let(:node) {
    Node.new(id: '0', title: 'Import').tap{|n|
      n << Node.new(id: '01', title: 'User')
      n << Node.new(id: '02', title: 'Func')
      n.item('01') << Node.new(id: '01.01', title: 'Story 1')
      n.item('01') << Node.new(id: '01.02', title: 'Story 2')
    }
  }

  let(:writer) { FakeWriter.new(node) }

  describe '#folder' do
    it 'must return parent.id + parent.name' do
      spec = writer.node.map{|n| writer.folder(n)}
      _(spec).must_equal([
        '', '', '01 User/', '01 User/', ''
      ])
    end
  end

  describe '#filename' do
    it 'must return node.id + node.title' do
      spec = writer.node.map{|n| writer.filename(n)}
      _(spec).must_equal([
        '0 Import.md', '01 User.md', '01.01 Story 1.md',
        '01.02 Story 2.md', '02 Func.md'
      ])
    end
  end

  describe '#source' do
    # title and first level shall be paced in root folder
    it 'must return node.id + node.title' do
      spec = writer.node.map{|n| writer.source(n)}
      _(spec).must_equal([
        '0 Import.md',
        '01 User.md',
        '01 User/01.01 Story 1.md',
        '01 User/01.02 Story 2.md',
        '02 Func.md'
      ])
    end
  end

  describe '#write(node)' do
    let(:node) {
      Node.new(id: '0', title: 'Import').tap{|n|
        n << Node.new(id: '01', title: 'User')
        n << Node.new(id: '02', title: 'Func')
        n.item('01') << Node.new(id: '01.01', title: 'Story 1')
        n.item('01') << Node.new(id: '01.02', title: 'Story 2')
        n.node('01.01') << Node.new(id: '01.01.01', title: 'Story 1.1')
        n.node('01.01') << Node.new(id: '01.01.02', title: 'Story 1.2')
      }
    }

    it 'must build repo' do
      files = ['0 Import.md', '01 User.md', '01 User/01.01 Story 1.md']
      Dir.mktmpdir(['clerq']) do |dir|
        Dir.chdir(dir) do
          ColonizeRepo.(node)
          files.each{|fn| _(File.exist?(fn)).must_equal true }
          _(File.read('0 Import.md')).wont_match "parent:"
          _(File.read('01 User.md')).must_match "parent: 0"
          _(File.read('01 User/01.01 Story 1.md')).must_match "parent: 01"
        end
      end

    end
  end

end
