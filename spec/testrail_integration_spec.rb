# frozen_string_literal: true

Bundler.require
require_all 'features/support/lib'

describe 'Testrail' do
  include Testrail

  context 'when the testrail environment
  variable is not set' do
    it 'will not have tetrail enabled' do
      expect(testrail_enabled).to be false
    end
  end

  context 'when the testrail environment
  variable is set to false' do
    it 'will not have tetrail enabled' do
      ENV['TESTRAIL'] = 'false'

      expect(testrail_enabled).to be false
    end
  end

  context 'when the testrail environment
  variable is set to true' do
    it 'will have testrail enabled' do
      ENV['TESTRAIL'] = 'true'

      expect(testrail_enabled).to be true
    end

    context 'but missing any of the other
    required testrail environment variables' do
      it 'will abort the run' do
        ENV['TESTRAIL'] = 'true'

        expect(missing_testrail_environment_variables).to be true
      end
    end

    context 'but the url for testrail is wrong' do
      it 'will abort the run' do
        ENV['TESTRAIL'] = 'true'
        ENV['TESTRAIL_URL'] = 'https://invalid_url.testrail.net'

        expect(testrail_credentials_invalid).to be true
      end
    end

    context 'but the username for testrail is wrong' do
      it 'will abort the run' do
        set_invalid_username_env_variables

        expect(testrail_credentials_invalid).to be true
      end
    end

    context 'but the password for testrail is wrong' do
      it 'will abort the run' do
        set_invalid_password_env_variables

        expect(testrail_credentials_invalid).to be true
      end
    end

    context 'but the project ID is invalid' do
      it 'will not add a new test run in Testrail' do
        set_invalid_testrail_project_env_variables

        expect(valid_testrail_project).to be false
      end

      it 'will print helper text to user that
      project id is incorrect' do
        set_invalid_testrail_project_env_variables

        expect(valid_testrail_project).to be false
      end
    end

    context 'and the credentials and project id is valid' do
      it 'will add a new test run in Testrail' do
        set_valid_testrail_env_variables

        expect(valid_testrail_project).to be true
      end
    end
  end

  context 'when a scenario is not already in the testrail project' do
    it 'the scenario_in_project? method will be false' do
      set_scenario_not_in_project_env_variables
      @scenario = fake_scenario

      expect(scenario_in_project?).to be false
    end
  end

  context 'when a scenario is already in the testrail project' do
    it 'the scenario_in_project? method will be true' do
      set_scenario_in_project_env_variables
      @scenario = fake_scenario

      expect(scenario_in_project?).to be true
    end
  end

  context 'when a scenario is to be added to testrail' do
    it "the scenario's gherkin will be corect" do
      set_valid_testrail_env_variables
      @scenario = fake_scenario

      expect(scenario_gherkin).to eq expected_gherkin
    end
  end

  context 'when the version (milestone) already is available in testrail' do
    it 'will return the milestone' do
      set_valid_testrail_env_variables
      ENV['VERSION'] = 'AlreadyThere1'

      expect(milestone_with_version).not_to be nil
    end

    it 'will return a milestone id' do
      set_valid_testrail_env_variables
      ENV['VERSION'] = 'AlreadyThere1'
      milestone = milestone_with_version || add_milestone

      expect(milestone['id']).to be > 0
    end
  end

  context 'when the version (milestone) is not available in testrail' do
    it 'will not return the milestone' do
      set_valid_testrail_env_variables
      ENV['VERSION'] = 'NotThere1'

      expect(milestone_with_version).to be nil
    end

    it 'will return a milestone id' do
      set_valid_testrail_env_variables
      ENV['VERSION'] = 'NotThere1'
      milestone = milestone_with_version || add_milestone

      expect(milestone['id']).to be > 0
    end
  end

  context 'when the scenario fails with a error
          message longer than 250 characters' do
    it 'will truncate the error message so it fits 250 characters' do
      @scenario = OpenStruct.new(
        exception: OpenStruct.new(
          message: error_message_more_than_250_characters
        )
      )

      expect(error_message.size).to be < 250
    end
  end

  context 'when the scenario fails with an error
          message less than 250 characters' do
    it 'will keep the entire error message' do
      @scenario = OpenStruct.new(
        exception: OpenStruct.new(
          message: error_message_less_than_250_characters
        )
      )

      expect(error_message).to eq error_message_less_than_250_characters
    end
  end

  context 'when the scenario does not fail' do
    it 'it will not have an error message' do
      @scenario = OpenStruct.new(
        exception: nil
      )

      expect(error_message).to be nil
    end
  end

  context 'when a scenario has finished running' do
    it 'will have an elapsed time' do
      @scenario_start_time = Time.now

      expect(scenario_elapsed_time).not_to be nil
    end
  end
end

def error_message_less_than_250_characters
  'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'\
  ' Aenean commodo ligula eget dolor. Aenean massa. Cum sociis'\
  ' natoque penatibus et magnis dis parturient montes, nascetur'\
  ' ridiculus mus. Donec quam felis, ultricies nec, pellentesque'
end

def error_message_more_than_250_characters
  'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'\
  ' Aenean commodo ligula eget dolor. Aenean massa. Cum sociis'\
  ' natoque penatibus et magnis dis parturient montes, nascetur'\
  ' ridiculus mus. Donec quam felis, ultricies nec, pellentesque'\
  ' eu, pretium quis, sem. Nulla consequat massa quis enim. Donec.'
end

def set_invalid_testrail_project_env_variables
  ENV['TESTRAIL'] = 'true'
  ENV['TESTRAIL_URL'] = 'https://invalid_project_id.testrail.net'
  ENV['TESTRAIL_USERNAME'] = 'valid@username.com'
  ENV['TESTRAIL_USERNAME'] = 'validPassword'
  ENV['TESTRAIL_PROJECT_ID'] = 'InvalidID'
end

def set_valid_testrail_env_variables
  ENV['TESTRAIL'] = 'true'
  ENV['TESTRAIL_URL'] = 'https://valid_project_id.testrail.net'
  ENV['TESTRAIL_USERNAME'] = 'valid@username.com'
  ENV['TESTRAIL_USERNAME'] = 'validPassword'
  ENV['TESTRAIL_PROJECT_ID'] = '1'
end

def set_invalid_username_env_variables
  ENV['TESTRAIL'] = 'true'
  ENV['TESTRAIL_URL'] = 'https://invalid_credentials.testrail.net'
  ENV['TESTRAIL_USERNAME'] = 'invalid@username.com'
  ENV['TESTRAIL_USERNAME'] = 'validPassword'
  ENV['TESTRAIL_PROJECT_ID'] = '1'
end

def set_invalid_password_env_variables
  ENV['TESTRAIL'] = 'true'
  ENV['TESTRAIL_URL'] = 'https://invalid_credentials.testrail.net'
  ENV['TESTRAIL_USERNAME'] = 'valid@username.com'
  ENV['TESTRAIL_USERNAME'] = 'invalidPassword'
  ENV['TESTRAIL_PROJECT_ID'] = '1'
end

def set_scenario_not_in_project_env_variables
  ENV['TESTRAIL'] = 'true'
  ENV['TESTRAIL_URL'] = 'https://scenario-not-in-project.testrail.net'
  ENV['TESTRAIL_USERNAME'] = 'valid@username.com'
  ENV['TESTRAIL_USERNAME'] = 'validPassword'
  ENV['TESTRAIL_PROJECT_ID'] = '1'
end

def set_scenario_in_project_env_variables
  ENV['TESTRAIL'] = 'true'
  ENV['TESTRAIL_URL'] = 'https://scenario-already-in-project.testrail.net'
  ENV['TESTRAIL_USERNAME'] = 'valid@username.com'
  ENV['TESTRAIL_USERNAME'] = 'validPassword'
  ENV['TESTRAIL_PROJECT_ID'] = '1'
end

def fake_scenario
  OpenStruct.new(
    name: 'this is a test Scenario',
    all_source: fake_sources
  )
end

def fake_sources
  [
    struct('Feature', 'this is a test Feature'),
    struct('Scenario', 'this is a test Scenario'),
    struct('Given ', 'this is a test Given step'),
    struct('When ', 'this is a test When step'),
    struct('And ', 'this is a test And step'),
    struct('Then ', 'this is a test Then step'),
    struct('But ', 'this is a test But step')
  ]
end

def struct(keyword, text)
  OpenStruct.new(
    keyword: keyword,
    text: text
  )
end

def expected_gherkin
  "Given this is a test Given step\n"\
  "When this is a test When step\n"\
  "And this is a test And step\n"\
  "Then this is a test Then step\n"\
  'But this is a test But step'
end
