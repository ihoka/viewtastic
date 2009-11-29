require File.dirname(__FILE__) + '/../spec_helper'

describe Viewtastic::Base do
  describe ".presents" do
    it "creates writable attributes from each model" do
      presenter = UserPresenter.new
      presenter.should respond_to(:user)
      presenter.should respond_to(:user=)
    end
  end
  
  describe "#new" do
    before(:each) do
      @user = User.new
    end
    
    it "initializes with options" do
      presenter = UserPresenter.new(:user => @user)
      presenter.user.should == @user
    end
    
    it "initializes with models" do
      presenter = UserPresenter.new(@user)
      presenter.user.should == @user
    end
  end
  
  describe "delegates" do
    before(:each) do
      @user = User.new(:login => "smarsh")
    end
    
    it "each message to its respective model" do
      presenter = UserPresenter.new(@user)
      presenter.user_login.should == "smarsh"
    end
    
    it "mapped attributes to their models" do
      presenter = UserPresenter.new(@user)
      presenter.login.should == "smarsh"
    end
  end
end