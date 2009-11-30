require 'spec_helper'

describe "Array#each_with_presenter" do
  before(:each) do
    @users =  %w[bob john sam].map { |login| User.new(:login => login) }
  end
  
  it "iterates over the elements yielding the element wrapped in a presenter with specified options" do
    i = 0
    @users.each_with_presenter(UserPresenter, :user, :foo => "foo") do |user_presenter|
      user_presenter.should be_an_instance_of(UserPresenter)
      user_presenter.foo.should == "foo"
      user_presenter.user.should == @users[i]
      
      i += 1
    end
  end
  
  it "recycles the user presenter instance" do
    presenters = []
    @users.each_with_presenter(UserPresenter, :user) do |user_presenter|
      presenters << user_presenter
    end
    presenters.uniq.size.should == 1
  end
end
