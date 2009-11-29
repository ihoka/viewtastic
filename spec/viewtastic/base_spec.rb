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
      @presenter = UserPresenter.new(@user)
      
      # Why are messages enforced on the controller actually being caught on
      # controller.request? Too many method_missing chains?
      @ctrl = controller.request
    end
    
    it "each message to its respective model" do
      @presenter.user_login.should == "smarsh"
    end
    
    it "mapped attributes to their models" do
      @presenter.login.should == "smarsh"
    end
    
    it "path and url helpers to the controller" do
      @ctrl.should_receive(:users_path).and_return("/users")
      @presenter.users_path.should == "/users"
    end
    
    [:dom_id, :protect_against_forgery?, :request_forgery_protection_token, :form_authenticity_token].each do |message|
      it "##{message} to the controller" do
        @ctrl.should_receive(message)
        @presenter.send(message)
      end
    end
    
    it "dom_ids for each model" do
      @ctrl.should_receive(:dom_id).with(@user, :prefix).and_return("user-dom-id")
      @presenter.user_dom_id(:prefix).should == "user-dom-id"
    end
  end
end
