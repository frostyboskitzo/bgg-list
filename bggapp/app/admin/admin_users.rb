ActiveAdmin.register AdminUser do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  # Limit actions available to your users by adding them to the 'except' array
  # actions :all, except: []

  # Add or remove filters (you can use any ActiveRecord scope) to toggle their
  # visibility in the sidebar
  # filter :id
  # filter :email
  # filter :encrypted_password
  # filter :reset_password_token
  # filter :reset_password_sent_at
  # filter :remember_created_at
  # filter :created_at
  # filter :updated_at

  # Add or remove columns to toggle their visiblity in the index action
  # index do
  #   selectable_column
  #   id_column
  #   column :id
  #   column :email
  #   column :encrypted_password
  #   column :reset_password_token
  #   column :reset_password_sent_at
  #   column :remember_created_at
  #   column :created_at
  #   column :updated_at
  #   actions
  # end

  # Add or remove rows to toggle their visiblity in the show action
  # show do |adminuser|
  #   row :id
  #   row :email
  #   row :encrypted_password
  #   row :reset_password_token
  #   row :reset_password_sent_at
  #   row :remember_created_at
  #   row :created_at
  #   row :updated_at
  # end

  # Add or remove fields to toggle their visibility in the form
  # form do |f|
  #   f.inputs do
  #     f.input :email
  #     f.input :encrypted_password
  #     f.input :reset_password_token
  #     f.input :reset_password_sent_at
  #     f.input :remember_created_at
  #   end
  #   f.actions
  # end
  
end
