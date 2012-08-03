require 'spec_helper'

describe Factory do
  FactoryGirl.factories.each do |factory|
    describe "with factory for :#{factory.name}" do
      subject { FactoryGirl.build(factory.name) }

      it "is valid" do
        subject.valid?.should be, "#{factory.name}: #{subject.errors.full_messages}"
      end
    end
  end
end
