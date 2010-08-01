require File.dirname(__FILE__) + '/../spec_helper'

describe "Viewtastic activation" do
  it "is included in the controller" do
    ActionController::Base.included_modules.should include(Viewtastic::Activation)
  end
  
  it "is activated" do
    Viewtastic::Base.should be_activated
    Viewtastic::Base.controller = nil
    Viewtastic::Base.should_not be_activated
  end
  
  it "is threadsafe" do
    Viewtastic::Base.controller = nil
    Viewtastic::Base.controller.should be_nil
    
    thread1 = Thread.new do
      controller = Authlogic::TestCase::MockController.new
      Viewtastic::Base.controller = controller
      Viewtastic::Base.controller.should == controller
    end
    thread1.join
    
    thread2 = Thread.new do
      controller = Authlogic::TestCase::MockController.new
      Viewtastic::Base.controller = controller
      Viewtastic::Base.controller.should == controller
    end
    thread2.join
    
    Viewtastic::Base.controller.should be_nil
  end
end
