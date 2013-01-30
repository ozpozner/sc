require File.dirname(__FILE__) + '/../spec_helper'

describe Radio do
  it "should be valid" do
    Radio.new.should be_valid
  end
end
