require File.dirname(__FILE__) + '/../spec_helper'

describe Gps do
  it "should be valid" do
    Gps.new.should be_valid
  end
end
