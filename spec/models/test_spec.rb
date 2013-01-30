require File.dirname(__FILE__) + '/../spec_helper'

describe Test do
  it "should be valid" do
    Test.new.should be_valid
  end
end
