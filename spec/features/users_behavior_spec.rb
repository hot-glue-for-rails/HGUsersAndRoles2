require 'rails_helper'

describe 'interaction for UsersController' do
  include HotGlue::ControllerHelper
  include ActionView::RecordIdentifier

  # HOTGLUE-SAVESTART
  # HOTGLUE-END
  


  let!(:user1) {
    user = create(:user , 
                          name: FFaker::Movie.title )

    user.save!
    user
  }
  
  describe "index" do
    it "should show me the list" do
      visit users_path
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user1.roles)
    end
  end

  describe "new & create" do
    it "should create a new User" do
      visit users_path
      click_link "New User"
      expect(page).to have_selector(:xpath, './/h3[contains(., "New User")]')
      new_name = FFaker::Movie.title 
      find("[name='user[name]']").fill_in(with: new_name)

      click_button "Save"
      expect(page).to have_content("Successfully created")

      expect(page).to have_content(new_name)
      expect(page).to have_content(new_roles)
    end
  end


  describe "edit & update" do
    it "should return an editable form" do
      visit users_path
      find("a.edit-user-button[href='/users/#{user1.id}/edit']").click

      expect(page).to have_content("Editing #{user1.name.squish || "(no name)"}")
      new_name = FFaker::Movie.title 
      find("[name='user[name]']").fill_in(with: new_name)

      click_button "Save"
      within("turbo-frame#__#{dom_id(user1)} ") do
        expect(page).to have_content(new_name)
       expect(page).to have_content(new_roles)
      end
    end
  end 

  describe "destroy" do
    it "should destroy" do
      visit users_path
      accept_alert do
        find("form[action='/users/#{user1.id}'] > input.delete-user-button").click
      end
      expect(page).to_not have_content(user1.name)
      expect(User.where(id: user1.id).count).to eq(0)
    end
  end
end

