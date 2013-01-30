require File.dirname(__FILE__) + '/../spec_helper'

describe GpsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Gps.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Gps.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Gps.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(gps_url(assigns[:gps]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Gps.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Gps.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Gps.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Gps.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Gps.first
    response.should redirect_to(gps_url(assigns[:gps]))
  end

  it "destroy action should destroy model and redirect to index action" do
    gps = Gps.first
    delete :destroy, :id => gps
    response.should redirect_to(gps_url)
    Gps.exists?(gps.id).should be_false
  end
end
