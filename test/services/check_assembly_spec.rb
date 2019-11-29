require_relative '../spec_helper'
include Clerq::Entities
include Clerq::Services

describe CheckAssembly do

   class CheckSvc < CheckAssembly
     public_class_method :new
     def node=(n); @node = n; end
     def initialize(node = nil) super(node); end
     def nonuniq_id; super; end
     def print_nonuniq_id; super; end
     def print_lost_roots; super; end
     def print_lost_index; super; end
     def lost_links; super; end
     def print_lost_links; super; end
     def how_many_times(n); super(n); end
   end

   let(:spec) { CheckSvc.new }
   let(:node) { Node.new(id: '0', meta: {filename: '00'})}

   describe '#nonuniq_id' do
     it 'must return empty hash when not found' do
       spec.node = node
       _(spec.nonuniq_id).must_equal({})
     end

     it 'must return errors' do
       node << Node.new(id: node.id, meta: {filename: '01'})
       spec.node = node
       _(spec.nonuniq_id).must_equal({'0' => [node, node.items[0]]})
     end
   end

   describe '#print_nonuniq_id' do
     let(:func) { ->{ spec.print_nonuniq_id} }

     let(:fout0) { "Checking for duplicates in node ids... OK\n" }

     let(:node1) {
       Node.new(id: 'n0', meta: {filename: '00'}).tap{|n|
         n << Node.new(id: 'n1', meta: {filename: '00'})
         n << Node.new(id: 'n2', meta: {filename: '00'})
         n << Node.new(id: 'n2', meta: {filename: '00'})
         n << Node.new(id: 'n2', meta: {filename: '02'})
         n << Node.new(id: 'n2', meta: {filename: '01'})
       }
     }

     let(:fout1) {
       <<~EOF
         Checking for duplicates in node ids... 1 found
         - [n2] occured twice in '00', once in '01', once in '02'
       EOF
     }

     it 'must print' do
       spec.node = node
       _(proc{ func.call }).must_output fout0, ""

       spec.node = node1
       _(proc{ func.call }).must_output fout1, ""
     end
   end

   describe '#print_lost_roots' do
     let(:func) { ->{spec.print_lost_roots} }

     let(:fout0) { "Checking for lost roots in node parents... OK\n" }

     let(:node1) {
       Node.new(id: '0', meta: {filename: '00'}).tap{|n|
         n << Node.new(id: '1', meta: {parent: '01', filename: '01'})
         n << Node.new(id: '2', meta: {parent: '01', filename: '02'})
       }
     }

     let(:fout1) {
       <<~EOF
       Checking for lost roots in node parents... 2 found
       - {{parent: 01}} of '1' in '01'
       - {{parent: 01}} of '2' in '02'
       EOF
     }

     it 'must print' do
       spec.node = node
       _(proc{ func.call }).must_output fout0, ""

       spec.node = node1
       _(proc{ func.call }).must_output fout1, ""
     end
   end

   describe '#print_lost_index' do
     let(:func) { ->{spec.print_lost_index} }

     let(:fout0) { "Checking for lost items in order_index... OK\n" }

     let(:node1) {
       Node.new(id: '0', meta: {order_index: '1 2 3 4', filename: '00'}).tap{|n|
         n << Node.new(id: '1', meta: {parent: '01', filename: '01'})
         n << Node.new(id: '2', meta: {parent: '01', filename: '02'})
       }
     }

     let(:fout1) {
       <<~EOF
         Checking for lost items in order_index... 1 found
         - {{order_index: 3 4}} not found of node '0' in '00'
       EOF
     }

     it 'must print' do
       spec.node = node
       _(proc{ func.call }).must_output fout0, ""

       spec.node = node1
       _(proc{ func.call }).must_output fout1, ""
     end
   end

   describe '#lost_links' do
     it 'must return empty when non found' do
       spec.node = node
       _(spec.lost_links).must_equal({})
     end

     let(:body1) {"The body contains [[link1]] link and [[link2]]"}
     let(:body2) {"The body contains [[link2]] link"}

     it 'must find lost links' do
       node << Node.new(id: '1', body: body1)
       node << Node.new(id: '1', body: body2)
       spec.node = node
       _(spec.lost_links).must_equal({
         'link1' => [node.items[0]],
         'link2' => [node.items[0], node.items[1]]
       })
     end
   end

   describe '#print_lost_links' do
     let(:func) { ->{spec.print_lost_links} }

     let(:fout0) { "Checking for lost links in nodes body... OK\n" }

     let(:body1) {"The body contains [[link1]] link and [[link2]]"}
     let(:body2) {"The body contains [[link2]] link"}

     let(:node1) {
       Node.new(id: '0', meta: {filename: '00'}).tap{|n|
         n << Node.new(id: '1', body: body1, meta: {filename: '01'})
         n << Node.new(id: '2', body: body2, meta: {filename: '02'})
       }
     }

     let(:fout1) {
       <<~EOF
         Checking for lost links in nodes body... 2 found
         - [[link1]] in [1] of '01'
         - [[link2]] in [1] of '01', [2] of '02'
       EOF
     }

     it 'must print' do
       spec.node = node
       _(proc{ func.call }).must_output fout0, ""

       spec.node = node1
       _(proc{ func.call }).must_output fout1, ""
     end
   end
end
