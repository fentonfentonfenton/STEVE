Given("I visit youtube") do
 visit('https://www.youtube.com/watch?v=WUa_2lJ6Xks&start_radio=1&list=RDMMWUa_2lJ6Xks')
end

When("I click {string}") do |string|
page.body.split('5 years')[1].split
binding.pry
end

Then("I get comments") do
  pending # Write code here that turns the phrase above into concrete actions
end
