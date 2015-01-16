set_if_empty :github_deployment_payload, -> do
  {

  }
end

set_if_empty :github_deployment, -> do
  {
      auto_merge: false,
      environment: fetch(:rails_env)
  }
end

set_if_empty :github_deployment_api, -> do
  Capistrano::Github::API.new(fetch(:repo_url), fetch(:github_access_token))
end

namespace :github do

  namespace :deployment do
    desc 'Create new deployment'
    task :create do
      gh = fetch(:github_deployment_api)
      payload = fetch(:github_deployment_payload)
      config = fetch(:github_deployment).merge(payload: payload)
      branch = fetch(:branch)

      run_locally do
        set_if_empty :current_github_deployment, -> do
          deployment = gh.create_deployment(branch, config)
          info("Created GitHub Deployment #{deployment.id}")
          deployment
        end
      end

      fetch(:current_github_deployment)
    end

    [:pending, :success, :error, :failure].each do |status|
      desc "Mark current deployment as #{status}"
      task status => :create do
        run_locally do
          gh = fetch(:github_deployment_api)
          dep = fetch(:current_github_deployment)

          gh.create_deployment_status(dep.id, status)
          info("Marked GitHub Deployment #{dep.id} as #{status}")
        end
      end
    end
  end

  desc 'List Github deployments'
  task :deployments do
    gh = fetch(:github_deployment_api)
    env = fetch(:github_deployment)[:environment]
    gh.deployments(environment: env).each do |d|
      statuses = d.statuses.reverse
      puts "Deployment (#{statuses.last.state}): #{d.created_at} #{d.ref}@#{d.sha} to #{d.environment} by @#{d.creator_login} "

      statuses.each do |s|
        puts "\t#{s.created_at} state: #{s.state}"
      end
    end
  end
end
