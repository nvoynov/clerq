require_relative '../spec_helper'
include Clerq::Repositories

describe TemplateRepository do

  describe '#initialize' do
    it 'must initialize @items' do
      Sandbox.() do
        repository = TemplateRepository.new
        _(repository.items).must_equal []
      end
    end
  end

  describe '#items' do

    it 'must load templates from .tt and .erb files' do
      Sandbox.() do
        repository = TemplateRepository.new
        File.write('tt1.md.tt',  '1')
        File.write('tt2.md.erb', '2')
        File.write('t.md.erb.0', '0') # must be ingored
        _(repository.items.size).must_equal 2
      end
    end

    it 'must return template when id parameter provided' do
      Sandbox.() do
        repo = TemplateRepository.new
        File.write('tt1.md.tt',  '1')
        File.write('tt2.md.erb', '2')

        _(repo.items('tt1.md.tt')).wont_be_nil
        _(repo.items('tt2.md.erb')).wont_be_nil
        _(repo.items('tt1.md')).wont_be_nil
        _(repo.items('tt2.md')).wont_be_nil

        _(repo.items('1')).must_be_nil
      end
    end
  end

  describe '#save' do

    let(:template) {
      Template.new(id: 'b3.md.erb', body: 'body template 3')
    }

    it 'must raise ArgumentError for wrong argument' do
      Sandbox.() do
        repo = TemplateRepository.new
        _(proc {repo.save(10)}).must_raise ArgumentError
        _(proc {repo.save('')}).must_raise ArgumentError
      end
    end

    it 'must save template to file and place to @items' do
      Sandbox.() do
        repo = TemplateRepository.new
        repo.save(template)
        _(repo.items.size).must_equal 1
        _(File.exist?(template.id)).must_equal true
      end
    end
  end

end
