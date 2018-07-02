namespace :github do

  desc 'Notify Github about new deployment'
  task :create_deployment do
    gh = Capistrano::Github::API.new(fetch(:repo_url), fetch(:github_access_token))

    dep = gh.create_deployment(fetch(:branch), {
      environment: fetch(:stage),
      required_contexts: [], # force deploy
      auto_merge: false
    })

    set :dep_id, dep.id

    target = "http://#{primary(:app).hostname}"
    gh.create_deployment_status(fetch(:dep_id), :pending, target)
  end

  desc 'List Github deployments'
  task :deployments do
    gh = Capistrano::Github::API.new(fetch(:repo_url), fetch(:github_access_token))
    gh.deployments.each do |d|
      puts "Deployment: #{d.created_at} #{d.sha} by @#{d.creator_login} #{d.payload}"

      d.statuses.each do |s|
        puts "#{s.created_at} state: #{s.state}"
      end
    end
  end

  desc 'Finish Github deployment'
  task :finish_deployment do
    gh = Capistrano::Github::API.new(fetch(:repo_url), fetch(:github_access_token))

    target = primary(:app).hostname
    gh.create_deployment_status(fetch(:dep_id), :success, target)
  end

  desc 'Fail Github deployment'
  task :fail_deployment do
    gh = Capistrano::Github::API.new(fetch(:repo_url), fetch(:github_access_token))

    target = primary(:app).hostname
    gh.create_deployment_status(fetch(:dep_id), :failure, target)
  end

  before 'deploy:starting', 'github:create_deployment'
  after 'deploy:finished', 'github:finish_deployment'
  if Rake::Task.task_defined? 'deploy:failed'
    after 'deploy:failed', 'github:fail_deployment'
  end

end
