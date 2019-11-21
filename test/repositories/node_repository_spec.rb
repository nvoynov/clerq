require_relative '../spec_helper'
include Clerq::Repositories
include Clerq::Entities

describe NodeRepository do

  # brings protected methods accessible
  class FakeRepo < NodeRepository
    def glob(pattern = '')
      super(pattern)
    end

    def read(filename)
      super(filename)
    end

    def load
      super
    end

    def markup(n)
      super(n)
    end
  end

  let(:node) {
    Node.new(
      id: 'spec', title: 'Spec', body: 'Spec',
      meta: {originator: 'spec'})
  }

  describe '#markup' do
    let(:n1) { Node.new(id: 'id') }
    let(:n2) { Node.new(id: 'id', title: 'Spec') }
    let(:n3) { Node.new(id: 'id', title: 'Spec', body: 'Spec') }
    let(:n4) { Node.new(id: 'id', title: 'Spec', body: 'Spec', meta: {parent: 'p'}) }
    let(:n5) { Node.new(id: 'id', title: 'Spec', meta: {parent: 'p'}) }

    let(:m1) { "# [id] " }
    let(:m2) { "# [id] Spec" }
    let(:m3) { "# [id] Spec\n\nSpec" }
    let(:m4) { "# [id] Spec\n{{\nparent: p\n}}\n\nSpec" }
    let(:m5) { "# [id] Spec\n{{\nparent: p\n}}" }

    let(:samples) {{
      n1 => m1,
      n2 => m2,
      n3 => m3,
      n4 => m4,
      n5 => m5
    }}

    it 'must render markup' do
      repo = FakeRepo.new
      samples.each{|k,v| _(repo.markup(k)).must_equal "#{v}\n"}
    end

  end

  # it is a mess because of Dir.mktmpdir
  describe '#save' do
    it 'must check everything there' do
      Sandbox.() do
        repo = FakeRepo.new
        # it must raise ArgumentError for wrong parameters
        _(proc{ repo.save(1) }).must_raise ArgumentError
        # it must save node
        repo.save(node)
        _(repo.glob).must_include "#{node.id}.md"
        # it must raise StandardError when file exists
        _(proc{ repo.save(node) }).must_raise StandardError
      end
    end
  end

  describe '#load' do
    it 'must load all files and return Array<Node>' do
      Sandbox.() do
        repo = FakeRepo.new
        repo.save Node.new(id: 'p1', title: 'Part 1')
        repo.save Node.new(id: 'p2', title: 'Part 2')
        repo.save Node.new(id: 'p1.1', title: 'Part 1.1')
        repo.save Node.new(id: 'p1.2', title: 'Part 1.2')
        repo.inside do
          Dir.mkdir('p1');
          File.rename('p1.1.md', 'p1/p1.1.md')
          File.rename('p1.2.md', 'p1/p1.2.md')
        end
        load = repo.load
        _(load.size).must_equal 4
        _(load.first).must_be_kind_of Node
      end
    end
  end

  # and also mess (:
  describe '#assemble' do

    it 'must assemble' do
      Sandbox.() do
        repo = FakeRepo.new

        # when repo is empty it must return root node'
        node = repo.assemble
        _(node.title).must_equal Clerq.title

        # when repo has only one node it must return this node as root'
        repo.save Node.new(id: '1', title: 'Single node')
        node = repo.assemble
        _(node.title).must_equal "Single node"
      end
    end

  end

  describe '#subo!' do
  end

  describe '#eqid!' do
  end

end
