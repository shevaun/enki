require File.dirname(__FILE__) + '/../spec_helper'

describe CommentMailer do

  before(:each) do
    @comment = Comment.new({
      :author => 'Don Alias',
      :body   => 'This is a comment',
      :post   => Post.new
    })
    @comment.apply_filter
  end

  describe "notification" do
    subject { CommentMailer.notification(@comment).deliver }

    it "should set the correct from using enki configuration" do
      subject.from.should == ["shevaun.coker@gmail.com"]
    end

    it "should set the correct to using enki configuration" do
      subject.to.should == ["shevaun.coker@gmail.com"]
    end

    it "should set the correct subject using enki configuration" do
      subject.subject.should == "New comment notification"
    end

    it "should have right body" do
      subject.body.should == "New comment on .\n\nThis is a comment\n"
    end


  end


end
