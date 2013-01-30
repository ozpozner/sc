require File.dirname(__FILE__) + '/../spec_helper'

describe ClocksController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Clock.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Clock.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Clock.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(clock_url(assigns[:clock]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Clock.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Clock.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Clock.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Clock.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Clock.first
    response.should redirect_to(clock_url(assigns[:clock]))
  end

  it "destroy action should destroy model and redirect to index action" do
    clock = Clock.first
    delete :destroy, :id => clock
    response.should redirect_to(clocks_url)
    Clock.exists?(clock.id).should be_false
  end
end
