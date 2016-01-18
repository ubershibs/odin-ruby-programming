require "spec_helper"

describe "Enumerable" do
  let(:ary) { [1, 2, 3, 4, 5, 6] }
  let(:hash) { { :a=> 1, :b=> 2} }

  describe "#my_count" do
    it "returns a number" do
      expect(ary.my_count).to be_an_instance_of(Fixnum)
    end

    context "with non-enumerable object" do
      it { expect { nil.my_count }.to raise_error(NoMethodError) }
      it { expect { 15.my_count }.to raise_error(NoMethodError) }
      it { expect { "hello".my_count }.to raise_error(NoMethodError) } 
    end

    context "when empty" do 
      it { expect([].my_count).to eq(0) }
      it { expect({}.my_count).to eq(0) }
    end

    context "when array/hash has elements" do
      it { expect(ary.my_count).to eq(6) }
      it { expect(hash.my_count).to eq(2) }
    end
  
    context "with a block given" do
      let(:block) { proc {|n| n.odd? } }

      it "counts only odd numbers" do
        expect(ary.my_count(&block)).to eq(3)
      end
    end
  end

  describe "#my_select" do
    it "returns the same type of object" do
      expect(ary.my_select).to be_an_instance_of(Array)
      expect(hash.my_select).to be_an_instance_of(Hash)
    end

    context "with non-enumerable object" do
      it { expect { nil.my_select }.to raise_error(NoMethodError) }
      it { expect { 15.my_select }.to raise_error(NoMethodError) }
      it { expect { "hello".my_select }.to raise_error(NoMethodError) } 
    end

    context "when empty" do 
      it { expect([].my_select).to eq([]) }
      it { expect({}.my_select).to eq({}) }
    end

    context "when array/hash has elements" do
      it { expect(ary.my_select).to eq([1,2,3,4,5,6]) }
      it { expect(hash.my_select).to eq({:a=>1, :b=>2}) }
    end

    context "with a block given" do
      let(:block) { proc {|n| n.odd? } }

      it "selects only odd numbers" do
        expect(ary.my_select(&block)).to eq([1,3,5])
      end
    end
  end 
end 