RSpec.describe 'github:deployment:create' do
  include_context :capistrano
  include_context :rake

  it { is_expected.to be }

  context 'invoke' do
    subject(:invoke) { task.invoke }
    it { is_expected.to be }

    context 'with access token' do
      let(:api) { instance_double(Capistrano::Github::API) }

      before do
        env.set :github_deployment_api, api
      end

      after { invoke }

      it do
        expect(api).to receive(:create_deployment)
                           .with(branch, auto_merge: false, environment: stage, payload: {})
                           .and_return('some-id')
      end
    end
  end
end

[:pending, :success, :error, :failure].each do |status|
  RSpec.describe "github:deployment:#{status}" do
    include_context :capistrano
    include_context :rake

    it { is_expected.to be }
    it { expect(task.prerequisites).to include('github:deployment:create') }

    context 'invoke' do
      subject(:invoke) { task.invoke }
      it { is_expected.to be }

      context 'with access token' do
        let(:api) { instance_double(Capistrano::Github::API) }

        let(:deployment) { rand(10000) }

        before do
          env.set :github_deployment_api, api
          expect(api).to receive(:create_deployment).and_return(deployment)
        end

        after { invoke }

        it do
          expect(api).to receive(:create_deployment_status)
                             .with(deployment, status)
        end
      end
    end
  end
end
