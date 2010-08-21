class Users::TeacherAssistantsController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?
  include SortHelper

  def index
    sort_init 'last_name'
    sort_update
    params[:sort_clause] = sort_clause
    @teacher_assistants = TeacherAssistant.search(params)

    respond_to do |format|
      format.html # index.html.erb
      format.js { render :partial => "users/user_list", :locals => { :users => @teacher_assistants } }
    end
  end


  # We don't really want to show an individual person but rather the listing
  # of all people.
  def show
		redirect_to :action => :index
  end

  def new
    @teacher_assistant = TeacherAssistant.new
    render :action => :edit
  end

  def edit
    @teacher_assistant = TeacherAssistant.find(params[:id])
  end

  def create
    @teacher_assistant = TeacherAssistant.new(params[:teacher_assistant])

    if @teacher_assistant.save
      flash[:notice] = "Teacher Assistant '#{@teacher_assistant.full_name}' was successfully created."
      redirect_to @teacher_assistant
    else
      render :action => :new
    end
  end

  def update
    @teacher_assistant = TeacherAssistant.find(params[:id])

    if @teacher_assistant.update_attributes(params[:teacher_assistant])
      flash[:notice] = 'TeacherAssistant was successfully updated.'
      redirect_to @teacher_assistant
    else
      render :action => :edit
    end
  end

  def destroy
    @teacher_assistant = TeacherAssistant.find(params[:id])
    @teacher_assistant.destroy

    redirect_to teacher_assistants_url
      
  end
end
