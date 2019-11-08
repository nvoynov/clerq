require_relative "../spec_helper"
include Clerq::Entities

describe Node do

  describe '#initialize' do
    it 'must raise ArgumentError when called with wrong options' do
      proc{Node.new(id: 100)}.must_raise ArgumentError
      proc{Node.new(title: 100)}.must_raise ArgumentError
      proc{Node.new(body: 100)}.must_raise ArgumentError
      proc{Node.new(meta: [])}.must_raise ArgumentError
    end

    it 'must provide default values' do
      Node.new.tap {|n|
        n.id.must_be_empty
        n.title.must_be_empty
        n.body.must_be_empty

        n.meta.wont_be_nil
        n.meta.must_be_kind_of Hash
        n.meta.must_be_empty

        n.parent.must_be_nil
        n.items.must_be_empty
      }
    end

    it 'must create node by parameters' do
      n = Node.new(id: 'u', title: 'User', body: 'This section', meta: {author: 'nvoynov'})
      n.id.must_equal 'u'
      n[:author].must_equal 'nvoynov'
      n.title.must_equal 'User'
      n.body.must_equal 'This section'
    end
  end

  describe '#parent=(value)' do
    class TestNode < Node; def parent=(value); super(value); end; end
    it 'must raise ArgumentError when value is not Node' do
      n = TestNode.new
      n.parent = n
      proc { n.parent = 1 }.must_raise ArgumentError
    end
  end

  describe '#<<(node)' do
    it 'must check parameter type' do
      proc { Node.new << nil }.must_raise ArgumentError
      proc { Node.new <<   1 }.must_raise ArgumentError
      proc { Node.new << '2' }.must_raise ArgumentError
    end

    it 'must add node to @items' do
      n1 = Node.new(id: '1')
      n1.items.must_be_empty
      n2 = Node.new(id: '1.1')
      n1 << n2
      n1.items.size.must_equal 1
      n2.items.size.must_equal 0
    end

    it 'must return node that was added' do
      n1 = Node.new
      n2 = Node.new
      n = n1 << n2
      n.must_equal n2
    end
  end

  describe '#each' do
    it 'must return Enumerator unless &block given' do
      n = Node.new
      n.each.must_be_kind_of Enumerator
    end

    it 'must enumerate whole hierarchy' do
      n = Node.new
      n1 = n.<<(Node.new)
      n2 = n.<<(Node.new)
      n11 = n1.<<(Node.new)
      n12 = n1.<<(Node.new)
      n21 = n2.<<(Node.new)
      n.to_a.must_equal [n, n1, n11, n12, n2, n21]
    end
  end

  describe '#id' do
    it 'must return id for regular id' do
      r = Node.new(id: 'regular')
      r.id.must_equal 'regular'
      # TODO: Fix behaviour for root?
      r = Node.new(id: '.regular')
      r.id.must_equal '.regular'
    end

    it 'must return id for relative id' do
      r = Node.new(id: 'regular')
      n = r.<<(Node.new(id: '.relative'))
      n.id.must_equal 'regular.relative'
    end
  end

  describe '#node(id)' do
    let(:repo) {
      r = Node.new(id: 'SRS')
      u = r.<<(Node.new(id: 'ur'))
      u << Node.new(id: '.us')
      u << Node.new(id: '.uc')
      r << Node.new(id: 'fr')
      r
    }

    it 'must return node by id' do
      n = repo.node('ur.us')
      n.id.must_equal 'ur.us'
    end

    it 'must return node by *id' do
      n = repo.node('*us')
      n.id.must_equal 'ur.us'
    end

    it 'must return nil when node not found' do
      repo.node('zombi').must_be_nil
      repo.node('*zombi').must_be_nil
    end
  end

  let(:node) {
    class SpecNode < Node
      def item(id)
        super(id)
      end
    end
    tree = SpecNode.new(id: 'u')
    tree << SpecNode.new(id: '.adm')
    tree << SpecNode.new(id: '.viz')
    tree << SpecNode.new(id: '.usr')
    tree
  }

  describe '#item(id)' do
    it 'must return node by regular id' do
      n = node.item('u.adm')
      n.wont_be_nil
      node.item('zombi').must_be_nil
    end

    it 'must return node by relative id' do
      n = node.item('.adm')
      n.wont_be_nil
      n.id.must_equal 'u.adm'
    end
  end

  describe 'meta[:order_index]' do
    it 'must return as-is, when :order_index not provided' do
      node[:order_index] = ''
      node.map(&:id).must_equal ['u', 'u.adm', 'u.viz', 'u.usr']
    end

    it 'must return items by full :order_index' do
      node[:order_index] = '.viz .usr .adm'
      node.map(&:id).must_equal ['u', 'u.viz', 'u.usr', 'u.adm']
    end

    it 'must return items partial :sort_order' do
      node[:order_index] = '.viz'
      node.map(&:id).must_equal ['u', 'u.viz', 'u.adm', 'u.usr']
    end
  end

  describe '#root' do
    it 'must return self for single node' do
      n = Node.new(id: '1')
      _(n.root).must_equal n
    end

    it 'must return top through #parent' do
      root = Node.new
      n01 = root << Node.new
      n02 = root << Node.new
      n11 = n01 << Node.new
      _(n01.root).must_equal root
      _(n02.root).must_equal root
      _(n11.root).must_equal root
    end
  end

  describe '#orphan!' do
    it 'must orphan! node from parent' do
      root = Node.new(id: 'r')
      root << Node.new(id: 'o')
      o = root.node('o')
      o.parent.must_equal root
      o.orphan!
      o.parent.must_be_nil
      root.node('o').must_be_nil
    end

    it 'must orphan! where there is nothint to orphan' do
      Node.new.orphan!
    end
  end

end
