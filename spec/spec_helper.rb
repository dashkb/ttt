require 'ttt'

TEST_DIR = File.expand_path('../test_game', __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.after(:each) { `rm -rf #{TEST_DIR}` }
end
