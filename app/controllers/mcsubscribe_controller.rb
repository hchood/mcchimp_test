class McsubscribeController < ApplicationController
  def index
  end

  def subscribe
    first_name = params[:person][:first_name]
    last_name = params[:person][:last_name]
    company = params[:person][:company]
    email = params[:person][:email]

    if !email.blank?

      begin

        @mc.lists.subscribe(@list_id, {'email' => email, 'first_name' => first_name, 'last_name' => last_name, 'company' => company})

        respond_to do |format|
          format.html{redirect_to root_path, notice: "Success! Check your email to confirm sign up."}
          format.json{render :json => {:notice => "Success! Check your email to confirm sign up."}}
        end

      rescue Mailchimp::ListAlreadySubscribedError

        respond_to do |format|
          format.html{redirect_to root_path, notice: "#{email} is already subscribed to the list"}
          format.json{render :json => {:notice => "#{email} is already subscribed to the list"}}
        end

# NEED TO FIX ERRORS BELOW

      rescue Mailchimp::ListDoesNotExistError

        respond_to do |format|
          format.json{render :json => {:message => "The list could not be found."}}
        end

      rescue Mailchimp::Error => ex

        if ex.message

          respond_to do |format|
            format.json{render :json => {:message => "There is an error. Please enter valid email id."}}
          end

        else

          respond_to do |format|
            format.json{render :json => {:message => "An unknown error occurred."}}
          end
        end

      end

    else

      respond_to do |format|
        format.json{render :json => {:message => "Email Address Cannot be blank. Please enter valid email id."}}
      end

    end
  end
end
