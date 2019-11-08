require_relative '../spec_helper'
include Clerq::Repositories
include Clerq::Entities

describe InMemory do

  let(:repo) { InMemory.new }

  it 'must save something' do
    repo.save(Node.new(id: 'u'))
    repo.save(Node.new(id: '.us', meta: {parent: 'u'}))
    repo.save(Node.new(id: '.uc', meta: {parent: 'u'}))
    repo.save(Node.new(meta: {parent: 'u.uc'}))
    repo.save(Node.new(meta: {parent: 'u.uc'}))
    repo.save(Node.new())
    repo.items.count.must_equal 6
  end

end
