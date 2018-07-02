require 'rake'

RSpec.shared_context :rake do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "capistrano/tasks/#{task_name.split(":").first}" }
  subject(:task)  { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == "#{task_path}.rake" }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, $LOAD_PATH, loaded_files_excluding_current_rake_file)
  end
end
