RSpec.shared_context :capistrano do
  let(:env) { Capistrano::Configuration.env }

  let(:repo_url) { 'git@github.com:capistrano/github.git' }
  let(:branch) { 'master' }
  let(:stage) { 'production' }

  before do
    Capistrano::Configuration.reset!

    env.set :repo_url, repo_url
    env.set :branch, branch
    env.set :stage, stage
  end
end

