require 'spec_helper'

describe "LayoutLinks" do

  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :key => "Home")
  end

  it "should have a about page at '/'" do
    get '/about'
        response.should have_selector('title', :content => "About")
  end

   it "should have a home page at '/'" do
    get '/Home'
        response.should have_selector('title', :content => "Home")
      end


end
