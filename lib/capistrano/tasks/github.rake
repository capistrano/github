set_if_empty :github_deployment_payload, -> do
  {
      environment: fetch(:rails_env)
  }
end

set_if_empty :github_deployment_api, -> do
  Capistrano::Github::API.new(fetch(:repo_url), fetch(:github_access_token))
end

namespace :github do

  namespace :deployment do
    desc "Create new deployment"
    task :create do
      gh = fetch(:github_deployment_api)
      payload = fetch(:github_deployment_payload)

      set_if_empty :github_deployment, -> do
        deployment = gh.create_deployment(fetch(:branch), force: true, payload: payload)
        info("Created GitHub Deployment #{deployment.id}")
        deployment
      end

      fetch(:github_deployment)
    end

    [:pending, :success, :error, :failure].each do |status|
      desc "Mark current deployment as #{status}"
      task status => :create do
        gh = fetch(:github_deployment_api)
        dep = fetch(:github_deployment)

        gh.create_deployment_status(dep.id, status)
        info("Marked GitHub Deployment #{dep.id} as #{status}")
      end
    end
  end

  desc 'List Github deployments'
  task :deployments do
    gh = Capistrano::Github::API.new(fetch(:repo_url), fetch(:github_access_token))
    gh.deployments.each do |d|
      puts "Deployment: #{d.created_at} #{d.sha} by @#{d.creator_login} #{d.payload.inspect}"

      d.statuses.each do |s|
        puts "#{s.created_at} state: #{s.state}"
      end
    end
  end
end
