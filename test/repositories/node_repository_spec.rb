require_relative '../spec_helper'
include Clerq::Repositories

describe NodeRepository do
  # bring protected methods to public
  class NodeRepo < NodeRepository
    def get_items; @items; end
    def load_nodes; super(); end
    def save_node(tt); super(tt); end
    def remove_node(tt); super(tt); end
  end

  describe '#initialize' do
    it 'must initialize @items' do
      repository = NodeRepo.new
      repository.get_items.wont_be_nil
      repository.get_items.must_be_kind_of Array
      repository.get_items.must_be_empty
    end
  end

  describe '#save and #load' do
    it 'must load node files' do
      Sandbox.() do
        repository = NodeRepo.new
        repository.save(Node.new(id: 'id.1', title: 'Title 1'))
        repository.save(Node.new(id: 'id.2', title: 'Title 2'))
        File.exist?('id.1.md').must_equal true
        File.exist?('id.2.md').must_equal true
        repository.load_nodes
        repository.items.wont_be_empty
        repository.items.size.must_equal 2
      end
    end
  end

end
