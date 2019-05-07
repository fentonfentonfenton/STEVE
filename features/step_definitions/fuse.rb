class Login < SitePrism::Page
  set_url 'https://rainforestqa.staging.fuseuniversal.com'
  element :username, 'input[id="user_login_name"]'
  element :password, 'input[id="user_password"]'
  element :login_button, 'input[class="b-sign-in-submit-button button login-button"]'
  element :cookies, 'button[class="b-accept-button"]'
  element :profile, 'img[class="b-my-profile-image"]'
end

class Logout < SitePrism::Page
  set_url 'https://rainforestqa.staging.fuseuniversal.com/users/sign_out'
end

Given("I visit fuse's staging website") do
  @login = Login.new
  @login.load
  expect(@login.current_url).to end_with('/users/sign_in')
end

Given("log in") do
  @login.username.set 'jack.fenton'
  @login.password.set 'jack.fenton'
  @login.login_button.click
end

And("I am logged in") do
  @login.cookies.click if @login.has_cookies?
  expect(@login).to have_profile
end

Then("I log out") do
 @logout = Logout.new
 @logout.load
 expect(@logout.current_url).to end_with('/users/sign_in')
 expect(@login).to have_no_profile
end
