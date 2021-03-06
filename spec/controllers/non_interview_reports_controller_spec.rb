# -*- coding: utf-8 -*-


require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe NonInterviewReportsController do

  # This should return the minimal set of attributes required to create a valid
  # NonInterviewReport. As you add validations to NonInterviewReport, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  context "with an authenticated user" do
    before(:each) do
      @contact_link = Factory(:contact_link)
      login(user_login)
    end

    describe "GET new" do

      it "should redirect if no contact_link_id parameter present"

      it "assigns a new non_interview_report as @non_interview_report" do
        get :new, :contact_link_id => @contact_link.id
        assigns(:non_interview_report).should be_a_new(NonInterviewReport)
      end
    end

    describe "GET edit" do

      it "should redirect if no contact_link_id parameter present"

      it "assigns the requested non_interview_report as @non_interview_report" do
        non_interview_report = NonInterviewReport.create! valid_attributes
        get :edit, :id => non_interview_report.id.to_s, :contact_link_id => @contact_link.id
        assigns(:non_interview_report).should eq(non_interview_report)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new NonInterviewReport" do
          expect {
            post :create, :non_interview_report => valid_attributes, :contact_link_id => @contact_link.id
          }.to change(NonInterviewReport, :count).by(1)
        end

        it "assigns a newly created non_interview_report as @non_interview_report" do
          post :create, :non_interview_report => valid_attributes, :contact_link_id => @contact_link.id
          assigns(:non_interview_report).should be_a(NonInterviewReport)
          assigns(:non_interview_report).should be_persisted
        end

        it "redirects to the created non_interview_report" do
          post :create, :non_interview_report => valid_attributes, :contact_link_id => @contact_link.id
          response.should redirect_to(edit_contact_link_path(@contact_link.id, :close_contact => true))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved non_interview_report as @non_interview_report" do
          # Trigger the behavior that occurs when invalid params are submitted
          NonInterviewReport.any_instance.stub(:save).and_return(false)
          post :create, :non_interview_report => {}, :contact_link_id => @contact_link.id
          assigns(:non_interview_report).should be_a_new(NonInterviewReport)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          NonInterviewReport.any_instance.stub(:save).and_return(false)
          post :create, :non_interview_report => {}, :contact_link_id => @contact_link.id
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested non_interview_report" do
          non_interview_report = NonInterviewReport.create! valid_attributes
          # Assuming there are no other non_interview_reports in the database, this
          # specifies that the NonInterviewReport created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          NonInterviewReport.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => non_interview_report.id, :non_interview_report => {'these' => 'params'}, :contact_link_id => @contact_link.id
        end

        it "assigns the requested non_interview_report as @non_interview_report" do
          non_interview_report = NonInterviewReport.create! valid_attributes
          put :update, :id => non_interview_report.id, :non_interview_report => valid_attributes, :contact_link_id => @contact_link.id
          assigns(:non_interview_report).should eq(non_interview_report)
        end

        it "redirects to the contact_link decision_page" do
          non_interview_report = NonInterviewReport.create! valid_attributes
          put :update, :id => non_interview_report.id, :non_interview_report => valid_attributes, :contact_link_id => @contact_link.id
          response.should redirect_to(decision_page_contact_link_path(@contact_link))
        end
      end

      describe "with invalid params" do
        it "assigns the non_interview_report as @non_interview_report" do
          non_interview_report = NonInterviewReport.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          NonInterviewReport.any_instance.stub(:save).and_return(false)
          put :update, :id => non_interview_report.id.to_s, :non_interview_report => {}, :contact_link_id => @contact_link.id
          assigns(:non_interview_report).should eq(non_interview_report)
        end

        it "re-renders the 'edit' template" do
          non_interview_report = NonInterviewReport.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          NonInterviewReport.any_instance.stub(:save).and_return(false)
          put :update, :id => non_interview_report.id.to_s, :non_interview_report => {}, :contact_link_id => @contact_link.id
          response.should render_template("edit")
        end
      end
    end
  end
end