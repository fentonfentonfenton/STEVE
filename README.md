# BB QA-AUTOMATION 2.0 aka STEVE

In the need of an awesome framework for you automated testing?

Look no further!

Steve's here at your service!

![baby.gif](https://i.imgflip.com/29n6nh.jpg)

Steve can do all the cool stuff:

- [x] Run your automation tests in Chrome?
- [x] Run your autoamtion tests in SauceLabs?
- [x] Take screenshots and save them in the cloud?
- [x] Integrate with TestRail so you can generate pretty reports?
- [x] Post resuls in Slack?
- [x] Run tests in parallel?


See? All the cool stuff!


## Getting Started

### Prerequisites

- Latest Ruby > 2.4.0
- Chrome
* [Follow this link](https://gitlab.com/MariusJorgensen/qa-automation) for chrome installation help
#### OR
- Docker
- TestRail account if you want to use that integration
- Some kind of Object Storage solution account that can use
S3 / AWS-SDK (tested on AWS and Digital Ocean) [If you want screenshots saved and embedded in TestRail reports]
- Saucelabs account if you want to use that integration


### Installing

```
bundle
```

## Running the tests on Chrome

```
cucumber
```

## Running the tests with SauceLabs

You can build a new rake task for any os/browser matrix you want. Just add it to the [Rakefile](Rakefile)

```
task :my_custom_os_browser_matrix do
  run_tests('macOS 10.12', 'Chrome', '62', 'saucelabs')
end
```

Then run
```
rake my_custom_os_browser_matrix
```

## Running the tests in Parallel

You can run your scenarios in parallel by splitting them up into sections. This can be done by features or tags.
Simply add the different sections as a new task in [cucumber_tasks.rake](lib/tasks/cucumber_tasks.rake)

```
namespace :cucumber do
  task :section_1 do
    system('bundle exec cucumber --tag @section1 --format pretty -c')
  end

  task :section_2 do
    system('bundle exec cucumber --tag @section2 --format pretty -c')
  end
end

```

Then run
```
rake parallel_testing
```

### Or with Docker
Note: You need to add the same environment variables in [docker-compose.yml](docker-compose.yml)
```
docker-compose build
docker-compose run app
```

## TestRail integration
This framework integrates with TestRail. Add your credentials described in the [Environment Variables](#environment-variables) section.

The structure it will create is:
* Scenarios are uploaded as Cases on a project level
* New Milestone is added for each version of what you are testing (Version is also an Environment Variable for now)
* If the Version is already saved as Milestone, it will use that
* New test runs are created, and each new scenario is added accordingly with result, error message, version, screenshot and elapsed time
* All results are uploaded at the end of a complete run
* Parallel testing = 1 test run
* SauceLabs testing = 1 test run per os/browser combination

## Screenshots
You should be able to use any kind of object storage service that is supported by the AWS SDK. We have used DigitalOcean's Spaces, so that works at least.

A new screenshot is uploaded accordingly to the credentials you have provided as Environment Variables.

The screenshots are saved with sha256'd names, and made public on the internet.  

### Environment Variables

- HEADLESS=true or false (you can run Chrome both in headless mode and normal)
- S3_BUCKET_NAME='your s3 bucket name'
- S3_BUCKET_URL='your s3 bucket url'
- S3_BUCKET_KEY='your s3 bucket key'
- S3_BUCKET_SECRET='your s3 bucket secret'
- S3_REGION='your s3 bucket region'
- S3_ENDPOINT='your s3 bucket endpoint'
- TESTRAIL_URL='your testrail url'
- TESTRAIL_USERNAME='your testrail username'
- TESTRAIL_PASSWORD='your testrail password'
- TESTRAIL_PROJECT_ID='testrail project id'
- TESTRAIL=true or false (if you don't want to run the TestRail integration)
- SCREENSHOTS=true or false (if you don't want to take screenshots during development or debugging)
- VERSION='what version you are testing, will be picked up automatically later'
- SAUCE_USERNAME='your sauce username'
- SAUCE_ACCESS_KEY='your sauce access key'
- SLACK_WEBHOOK_URL='slack webhook url'

## Built With

* [Cucumber-ruby](https://github.com/cucumber/cucumber-ruby) - BDD framework for writing tests in business domain
* [Capybara](https://github.com/teamcapybara/capybara) - BDD support for defining real world user interaction with the browser
* [TestRail](http://docs.gurock.com/testrail-api2/start) – Test Management Tool for reporting. Has Jira integration
* [Digitalocean Spaces](https://www.digitalocean.com/community/tutorials/an-introduction-to-digitalocean-spaces) – Object Storage for test artifacts (Or just use plain old AWS S3)
* [Docker](https://www.docker.com/) – A tool that can package an application and its dependencies in a virtual container that can run on any Linux server.
* [Saucelabs](https://saucelabs.com/) – Get immediate access to the world’s largest automated testing cloud for web and mobile applications.
* [Slack Webhook](https://api.slack.com/incoming-webhooks) – Post messages from external sources into Slack.


## Tests

```
rspec
```

## Authors

* **TEAM QA**


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details

## TODO

[TODO](TODO.md)
